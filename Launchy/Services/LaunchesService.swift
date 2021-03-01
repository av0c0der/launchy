//
//
//  Launchy
//  
//  Created on 27.02.2021
//  
//  

import Foundation
import RxSwift

/// Sorting operators.
struct LaunchesSorting {
    enum SortingType {
        /// Sort by date.
        case date
        /// Sort by upcoming flag.
        case upcoming
    }
    /// Sorting criteria
    let type: SortingType
    /// Sorting order
    var ascending = true
}

/// An interface to SpaceX Launches API. Provides a set of methods to request information about upcoming or completed rocket launches.
protocol LaunchesService {

    /// Request launches with a given criterias.
    /// - Parameters:
    ///   - minDate: Date of oldest launch to fetch.
    ///   - maxDate: Date of newest launch to fetch.
    ///   - limit: Number of items to be fetched.
    ///   - page: Number of items per request.
    ///   - sorting: Sorting options.
    ///   - upcoming: Fetch only upcoming launches or not.
    func fetchLaunches(minDate: Date?, maxDate: Date?, limit: Int, page: Int, sorting: [LaunchesSorting], upcoming: Bool?) -> Single<[Launch]>
}

/// Provides an implementaiton of LaunchesService.
enum LaunchesServiceProvider {
    static func makeLaunchesService(networkService: NetworkService) -> LaunchesService {
        LaunchesServiceImplementation(networkService: networkService)
    }
}

private final class LaunchesServiceImplementation: LaunchesService {

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    private let networkService: NetworkService
    private let apiV4BaseURL = URL(string: "https://api.spacexdata.com/v4")!

    /// Standard JSONDecoder which decodes dates in UNIX-timestamp format.
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    /// Standard JSONEncoder which encodes dates in ISO8601 format.
    private lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    /// Date range search query.
    struct DateRange: Encodable {
        enum CodingKeys: String, CodingKey {
            case min = "$gte", max = "$lte"
        }
        var min: Date?
        var max: Date?
    }

    /// Search query.
    struct RequestQuery: Encodable {
        let date_utc: DateRange
        let success: Bool?
        let upcoming: Bool?
    }

    /// Sorting criteria.
    struct SortItem {
        let key: String
        let ascending: Bool
        var dict: [String: String] {
            [key: ascending ? "asc" : "desc"]
        }
    }

    /// Sorting criterias.
    struct Sort: Encodable {
        let items: [SortItem]
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            let dict = Dictionary(uniqueKeysWithValues: items.flatMap(\.dict))
            try container.encode(dict)
        }
    }

    /// Pagination and sorting options.
    struct RequestOptions: Encodable {
        let limit: Int
        let page: Int
        let pagination = true
        let sort: Sort?
    }

    /// Request to the SpaceX API with search query and sorting.
    struct Request: Encodable {
        let query: RequestQuery
        let options: RequestOptions
    }

    /// Response from the SpaceX API.
    struct Response: Decodable {
        let docs: [Launch]
    }

    func fetchLaunches(minDate: Date?, maxDate: Date?, limit: Int, page: Int, sorting: [LaunchesSorting], upcoming: Bool?) -> Single<[Launch]> {

        let url = apiV4BaseURL
            .appendingPathComponent("launches")
            .appendingPathComponent("query")

        let request = Request(
            query: RequestQuery(
                date_utc: DateRange(min: minDate, max: maxDate),
                success: upcoming == nil ? true : nil,
                upcoming: upcoming
            ),
            options: RequestOptions(
                limit: limit,
                page: page,
                sort: Sort(items: sorting.map { option in
                    switch option.type {
                    case .date:
                        return SortItem(key: "date_utc", ascending: option.ascending)
                    case .upcoming:
                        return SortItem(key: "upcoming", ascending: option.ascending)
                    }
                })
            )
        )

        let requestConfig = RequestConfig(url: url, method: .post, parameters: request.getDictionary(using: jsonEncoder))
        return networkService.request(config: requestConfig)
            .decode(Response.self, using: jsonDecoder)
            .map(\.docs)
    }

}

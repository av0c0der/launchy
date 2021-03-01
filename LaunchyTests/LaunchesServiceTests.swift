//
//
//  LaunchyTests
//  
//  Created on 28.02.2021
//  
//  

import XCTest
@testable import Launchy

class LaunchesServiceTests: XCTestCase {

    var networkService: MockNetworkService!
    var launchesService: LaunchesService!

    override func setUp() {
        networkService = MockNetworkService()
        launchesService = LaunchesServiceProvider.makeLaunchesService(networkService: networkService)
    }

    func testRequestConfigHasCorrectParams() throws {
        _ = launchesService.fetchLaunches(minDate: nil, maxDate: nil, limit: 100, page: 1, sorting: [], upcoming: nil)

        let config = try XCTUnwrap(networkService.requestConfig)
        XCTAssertEqual(config.method.rawValue, "POST")

        XCTAssertEqual(try config.url.asURL().absoluteString, "https://api.spacexdata.com/v4/launches/query")
    }

    func testQueryParamatersAreCorrect() throws {
        let dateFormatter = ISO8601DateFormatter()
        let maxDate = Date()
        let minDate = Calendar.current.date(byAdding: .year, value: -3, to: maxDate)!

        _ = launchesService.fetchLaunches(minDate: minDate, maxDate: maxDate, limit: 100, page: 1, sorting: [], upcoming: nil)

        let params = try XCTUnwrap(networkService.requestConfig?.parameters)
        let query = try XCTUnwrap(params["query"] as? [String: Any])

        let dateQuery = try XCTUnwrap(query["date_utc"] as? [String: Any])

        let minDateString = try XCTUnwrap(dateQuery["$gte"] as? String)
        XCTAssertEqual(dateFormatter.string(from: minDate), minDateString)

        let maxDateString = try XCTUnwrap(dateQuery["$lte"] as? String)
        XCTAssertEqual(dateFormatter.string(from: maxDate), maxDateString)

        let successParam = try XCTUnwrap(query["success"] as? Bool)
        XCTAssert(successParam)
    }

    func testPaginationParametersAreCorrect() throws {
        let limit = 100
        let page = 1
        _ = launchesService.fetchLaunches(minDate: nil, maxDate: nil, limit: limit, page: page, sorting: [], upcoming: nil)

        let params = try XCTUnwrap(networkService.requestConfig?.parameters)

        let options = try XCTUnwrap(params["options"] as? [String: Any])

        XCTAssertEqual(options["limit"] as? Int, limit)

        XCTAssertEqual(options["pagination"] as? Bool, true)

        XCTAssertEqual(options["page"] as? Int, page)
    }

    func testSortingParametersAreCoorect() throws {
        _ = launchesService.fetchLaunches(minDate: nil, maxDate: nil, limit: 100, page: 1, sorting: [
            .init(type: .upcoming, ascending: false),
            .init(type: .date)
        ], upcoming: true)

        let params = try XCTUnwrap(networkService.requestConfig?.parameters)

        let query = try XCTUnwrap(params["query"] as? [String: Any])
        XCTAssertNil(query["success"])

        let upcomingParam = try XCTUnwrap(query["upcoming"] as? Bool)
        XCTAssert(upcomingParam)

        let options = try XCTUnwrap(params["options"] as? [String: Any])
        let sort = try XCTUnwrap(options["sort"] as? [String: Any])

        let dateSortParam = try XCTUnwrap(sort["date_utc"] as? String)
        XCTAssertEqual(dateSortParam, "asc")

        let upcomingSortParam = try XCTUnwrap(sort["upcoming"] as? String)
        XCTAssertEqual(upcomingSortParam, "desc")
    }

}

//
//
//  Launchy
//  
//  Created on 27.02.2021
//  
//  

import Foundation
import RxSwift

/// An interface to SpaceX Rockets API. Provides a set of methods to request information about SpaceX rockets.
protocol RocketsService {
    /// Request information about a rocket for a given identifier.
    /// - Parameter id: rocket identifier.
    func getRocket(id: String) -> Single<Rocket>
}

/// Provides a concrete implementation of RocketsService interface.
enum RocketsServiceProvider {
    static func makeRocketsService(networkService: NetworkService) -> RocketsService {
        RocketsServiceImplementation(networkService: networkService)
    }
}

private final class RocketsServiceImplementation: RocketsService {

    private let networkService: NetworkService
    private let apiV4BaseURL = URL(string: "https://api.spacexdata.com/v4")!

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getRocket(id: String) -> Single<Rocket> {
        let url = apiV4BaseURL
            .appendingPathComponent("rockets")
            .appendingPathComponent(id)
        let requestConfig = RequestConfig(url: url, method: .get)
        return networkService.request(config: requestConfig)
            .decode(Rocket.self)
    }

}

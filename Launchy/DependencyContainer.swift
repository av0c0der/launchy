//
//
//  Launchy
//  
//  Created on 01.03.2021
//  
//  

import Foundation

final class DependencyContainer {

    private let networkService: NetworkService
    private let launchesService: LaunchesService
    private let rocketsService: RocketsService

    init() {
        networkService = NetworkServiceProvider.makeNetworkService()
        launchesService = LaunchesServiceProvider.makeLaunchesService(networkService: networkService)
        rocketsService = RocketsServiceProvider.makeRocketsService(networkService: networkService)
    }

    func makeRocketsService() -> RocketsService {
        rocketsService
    }

    func makeLaunchesService() -> LaunchesService {
        launchesService
    }

    func makeNetworkService() -> NetworkService {
        networkService
    }

}

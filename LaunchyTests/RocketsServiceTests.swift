//
//
//  LaunchyTests
//  
//  Created on 01.03.2021
//  
//  

import XCTest
@testable import Launchy

class RocketsServiceTests: XCTestCase {

    var networkService: MockNetworkService!
    var rocketsService: RocketsService!

    override func setUp() {
        networkService = MockNetworkService()
        rocketsService = RocketsServiceProvider.makeRocketsService(networkService: networkService)
    }

    func testRequestConfigHasCorrectParams() throws {
        let id = UUID().uuidString
        _ = rocketsService.getRocket(id: id)

        let requestConfig = try XCTUnwrap(networkService.requestConfig)

        XCTAssertEqual(try requestConfig.url.asURL().absoluteString, "https://api.spacexdata.com/v4/rockets/\(id)")
        XCTAssertEqual(requestConfig.method.rawValue, "GET")
    }

}

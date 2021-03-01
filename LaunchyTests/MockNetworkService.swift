//
//
//  LaunchyTests
//  
//  Created on 28.02.2021
//  
//  

import Foundation
import RxSwift
@testable import Launchy

final class MockNetworkService: NetworkService {

    var requestConfig: RequestConfig?
    var dataToReturn = Data()

    func request(config: RequestConfig) -> Single<Data> {
        self.requestConfig = config
        return Single.just(dataToReturn)
    }

}

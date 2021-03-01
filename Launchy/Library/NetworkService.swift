//
//
//  Launchy
//  
//  Created on 27.02.2021
//  
//  

import Foundation
import Alamofire
import RxSwift

/// Defines a network request.
struct RequestConfig {
    /// Payload encoding type.
    enum Encoding {
        case url, json
    }

    /// A url to make request to.
    var url: URLConvertible
    /// HTTP method (verb) as GET, POST etc.
    var method: HTTPMethod
    /// A dictionary to encode to the request. Could be a json or a URL query.
    var parameters: Parameters? = nil
    /// Defines how parameters should be encoded.
    var encoding: Encoding = .url
}

/// Provides an interface to perform outbounding requests.
protocol NetworkService {
    /// Perform a network request with a given configuration.
    /// - Parameter config: request metadata.
    func request(config: RequestConfig) -> Single<Data>
}

/// Provides a NetworkService implementation.
enum NetworkServiceProvider {
    static func makeNetworkService() -> NetworkService {
        return NetworkServiceImplementation()
    }
}

private final class NetworkServiceImplementation: NetworkService {

    func request(config: RequestConfig) -> Single<Data> {
        return Single.create { future -> Disposable in
            let request = AF.request(config.url, method: config.method, parameters: config.parameters, encoding: config.encoding == .url ? URLEncoding.default : JSONEncoding.default)
                .responseData { response in
                    switch response.result {
                    case .failure(let error):
                        future(.failure(error))
                    case .success(let data):
                        future(.success(data))
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }

}

//
//
//  Launchy
//  
//  Created on 27.02.2021
//  
//  

import Foundation
import RxSwift

extension ObservableType where Element == Data {
    /// Decode the stream into a given type.
    func decode<T: Decodable>(_ type: T.Type, using decoder: JSONDecoder = .init()) -> Observable<T> {
        return map { data in
            try decoder.decode(type, from: data)
        }
    }
}

extension Single where Element == Data {
    /// Decode the stream into a given type.
    func decode<T: Decodable>(_ type: T.Type, using decoder: JSONDecoder = .init()) -> Single<T> {
        self.asObservable().decode(type: type, decoder: decoder).asSingle()
    }
}

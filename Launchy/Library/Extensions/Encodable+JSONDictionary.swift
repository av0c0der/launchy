//
//
//  Launchy
//  
//  Created on 28.02.2021
//  
//  

import Foundation

extension Encodable {
    /// Create JSON dictionary using a given JSONEncoder.
    func getDictionary(using encoder: JSONEncoder = .init()) -> [String: Any]? {
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any]
    }
}

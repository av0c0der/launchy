//
//
//  Launchy
//  
//  Created on 28.02.2021
//  
//  

import UIKit

extension NSObject {
    static var className: String {
        String(describing: Self.self)
    }
}

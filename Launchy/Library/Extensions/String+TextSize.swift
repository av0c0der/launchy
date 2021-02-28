//
//
//  Launchy
//  
//  Created on 27.02.2021
//  
//  

import UIKit

extension String {
    /// Get height of the string which fits to a given width.
    func height(with maxWidth: CGFloat, font: UIFont) -> CGFloat {
        return self.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
            .height
            .rounded(.up)
    }
}

//
//
//  Launchy
//  
//  Created on 28.02.2021
//  
//  

import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.className)
    }

    func registerNib<T: UICollectionViewCell>(_:T.Type) {
        let bundle = Bundle(for: T.classForCoder().self)
        let nib = UINib(nibName: T.className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.className)
    }

    func dequeue<T: UICollectionViewCell>(_: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as! T
    }

}

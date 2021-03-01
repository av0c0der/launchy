//
//
//  Launchy
//  
//  Created on 28.02.2021
//  
//  

import UIKit

final class LoadingCell: UICollectionViewCell {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    func startAnimating() {
        activityIndicatorView.startAnimating()
    }

    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }

}

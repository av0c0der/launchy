//
//
//  Launchy
//  
//  Created on 27.02.2021
//  
//  

import UIKit
import AlamofireImage

extension UIImageView {

    func cancelImageLoading() {
        af.cancelImageRequest()
    }

    func setImage(from url: URL?, placeholder: UIImage? = nil, contentMode: UIView.ContentMode = .scaleAspectFill, scaleSize: CGSize? = nil) {
        guard let url = url else { return }

        var imageFilter: ImageFilter?
        if let size = scaleSize {
            imageFilter = AspectScaledToFillSizeFilter(size: size)
        }

        af.setImage(withURL: url, placeholderImage: placeholder, filter: imageFilter, imageTransition: ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: false, completion: { [weak self] response in
            guard let view = self else { return }
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    view.contentMode = contentMode
                }
            case .failure:
                break
            }
        })
    }

}

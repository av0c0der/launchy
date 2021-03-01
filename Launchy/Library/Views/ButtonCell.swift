//
//
//  Launchy
//  
//  Created on 28.02.2021
//  
//  

import UIKit

struct ButtonCellViewModel: Equatable {
    static func == (lhs: ButtonCellViewModel, rhs: ButtonCellViewModel) -> Bool {
        lhs.text == rhs.text
    }

    var symbolName: String?
    let text: String
    let action: (() -> Void)
}

final class ButtonCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
    }

    func configure(viewModel: ButtonCellViewModel) {
        titleLabel.text = viewModel.text

        imageView.image = viewModel.symbolName.flatMap { name in
            UIImage(systemName: name)
        }
    }

}

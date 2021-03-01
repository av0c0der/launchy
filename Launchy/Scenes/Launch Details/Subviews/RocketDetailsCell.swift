//
//
//  Launchy
//  
//  Created on 28.02.2021
//  
//  

import UIKit

typealias RocketDetailsCellViewModel = Rocket

final class RocketDetailsCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    func configure(with viewModel: RocketDetailsCellViewModel) {
        titleLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
    }

}

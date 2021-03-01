//
//
//  Launchy
//  
//  Created on 28.02.2021
//  
//  

import UIKit

typealias LaunchDetailsCellViewModel = LaunchListItemViewModel

final class LaunchDetailsCell: UICollectionViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var upcomingBadgeView: UIView!
    @IBOutlet private weak var numberContainerView: UIView!
    @IBOutlet private weak var numberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        numberContainerView.layer.cornerRadius = 4
        upcomingBadgeView.layer.cornerRadius = 4
    }

    func configure(with viewModel: LaunchDetailsCellViewModel) {
        dateLabel.text = viewModel.date
        numberLabel.text = viewModel.number
        upcomingBadgeView.isHidden = !viewModel.isUpcoming
    }

    static func height(with width: CGFloat, viewModel: LaunchDetailsCellViewModel) -> CGFloat {
        return 70
    }

}

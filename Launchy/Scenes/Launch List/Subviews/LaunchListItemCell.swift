//
//
//  Launchy
//  
//  Created on 27.02.2021
//  
//  

import UIKit
import RxSwift

final class LaunchListItemCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var upcomingBadgeView: UIView!
    @IBOutlet private weak var launchNumberContainerView: UIView!
    @IBOutlet private weak var launchNumberLabel: UILabel!

    private var bag = DisposeBag()

    private static let padding: CGFloat = 16
    private static let titleFont = UIFont.preferredFont(forTextStyle: .headline)
    private static let dateFont = UIFont.preferredFont(forTextStyle: .caption1)
    private static let descriptionFont = UIFont.preferredFont(forTextStyle: .body)

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        launchNumberContainerView.layer.cornerRadius = 3
        upcomingBadgeView.layer.cornerRadius = 3

        backgroundColor = .systemBackground
        imageView.tintColor = .tertiaryLabel

        titleLabel.font = LaunchListItemCell.titleFont
        dateLabel.font = LaunchListItemCell.dateFont
        descriptionLabel.font = LaunchListItemCell.descriptionFont
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = .init()
        imageView.cancelImageLoading()
        imageView.image = UIImage(named: "launch_placeholder")
        upcomingBadgeView.isHidden = true
    }

    func configure(with viewModel: LaunchListItemViewModel) {
        titleLabel.text = viewModel.title
        launchNumberLabel.text = viewModel.number
        descriptionLabel.text = viewModel.description
        descriptionLabel.isHidden = viewModel.description == nil
        dateLabel.text = viewModel.date
        upcomingBadgeView.isHidden = !viewModel.isUpcoming
        imageView.setImage(from: viewModel.imageURL, scaleSize: bounds.size)
    }

    static func height(with maxWidth: CGFloat, viewModel vm: LaunchListItemViewModel) -> CGFloat {
        let maxWidth = maxWidth - padding * 2
        let padding: CGFloat = 16
        let spacing: CGFloat = 8
        let imageHeight: CGFloat = 200
        let dateHeight = vm.date.height(with: maxWidth, font: dateFont)
        let descriptionHeight: CGFloat
        if let desciption = vm.description {
            descriptionHeight = min(60, desciption.height(with: maxWidth, font: descriptionFont))
        } else {
            descriptionHeight = 0
        }
        let titleHeight: CGFloat = vm.title.height(with: maxWidth, font: titleFont)
        return (imageHeight
                    + padding
                    + dateHeight
                    + spacing
                    + titleHeight
                    + spacing
                    + descriptionHeight)
            .rounded(.up) + padding
    }

}

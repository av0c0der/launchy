//
//
//  Launchy
//  
//  Created on 28.02.2021
//  
//  

import UIKit

struct TextCellViewModel: Equatable {
    let text: String
    var textStyle: UIFont.TextStyle = .body
    var color: UIColor = .label

    static func body(_ text: String, color: UIColor = .secondaryLabel) -> Self {
        return .init(text: text, textStyle: .body, color: color)
    }

    static func title(_ text: String, color: UIColor = .label) -> Self {
        return .init(text: text, textStyle: .largeTitle, color: color)
    }

    static func header(_ text: String, color: UIColor = .label) -> Self {
        return .init(text: text, textStyle: .headline, color: color)
    }
}

final class TextCell: UICollectionViewCell {

    @IBOutlet private weak var textLabel: UILabel!

    func configure(with viewModel: TextCellViewModel) {
        textLabel.text = viewModel.text
        textLabel.font = UIFont.preferredFont(forTextStyle: viewModel.textStyle)
        textLabel.textColor = viewModel.color
    }

    static func height(with width: CGFloat, viewModel: TextCellViewModel) -> CGFloat {
        let height = viewModel.text.height(with: width, font: UIFont.preferredFont(forTextStyle: viewModel.textStyle))
        return height
    }

}

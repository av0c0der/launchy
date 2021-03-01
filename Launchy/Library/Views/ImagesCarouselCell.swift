//
//
//  Launchy
//  
//  Created on 28.02.2021
//  
//  

import UIKit
import RxSwift
import RxCocoa

typealias ImagesCarouselCellViewModel = ([URL])

final class ImagesCarouselCell: UICollectionViewCell {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageIndicator: UIPageControl!

    private let stackView = UIStackView()
    private var bag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        scrollView.addSubview(stackView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = .init()
        pageIndicator.numberOfPages = 0
        pageIndicator.currentPage = 0
        stackView.arrangedSubviews.forEach {
            ($0 as? UIImageView)?.cancelImageLoading()
            $0.removeFromSuperview()
        }
    }

    func configure(viewModel: ImagesCarouselCellViewModel) {
        var x: CGFloat = 0
        scrollView.layoutIfNeeded()
        let pageSize = scrollView.bounds.size
        let pageWidth = pageSize.width
        let pageHeight = pageSize.height

        for url in viewModel {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.setImage(from: url, placeholder: UIImage(named: "launch_placeholder"), contentMode: .scaleAspectFill, scaleSize: bounds.size)
            imageView.clipsToBounds = true
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: pageWidth),
                imageView.heightAnchor.constraint(equalToConstant: pageHeight),
            ])

            stackView.addArrangedSubview(imageView)
            x += pageWidth
        }

        let contentSize = CGSize(width: x, height: pageHeight)
        stackView.frame = CGRect(origin: .zero, size: contentSize)
        scrollView.contentSize = contentSize

        pageIndicator.currentPage = 0
        pageIndicator.numberOfPages = viewModel.count

        scrollView.rx.contentOffset.map(\.x)
            .map { Int($0 + pageWidth/2) / Int(pageWidth) }
            .asDriver(onErrorJustReturn: 0)
            .drive(pageIndicator.rx.currentPage)
            .disposed(by: bag)

        pageIndicator.rx.controlEvent(.valueChanged)
            .map { [unowned self] in self.pageIndicator.currentPage }
            .map { CGPoint(x: CGFloat($0) * pageWidth, y: 0) }
            .bind(to: scrollView.rx.contentOffset)
            .disposed(by: bag)
    }

}

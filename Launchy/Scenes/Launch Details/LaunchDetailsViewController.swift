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
import RxDataSources

final class LaunchDetailsViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    private let viewModel: LaunchDetailsViewModel

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<LaunchDetailsViewModel.Section>(configureCell: { dataSource, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {

        case .imagesCarousel(let vm):
            let cell = collectionView.dequeue(ImagesCarouselCell.self, indexPath: indexPath)
            cell.configure(viewModel: vm)
            return cell

        case .text(let vm):
            let cell = collectionView.dequeue(TextCell.self, indexPath: indexPath)
            cell.configure(with: vm)
            return cell

        case .details(let vm):
            let cell = collectionView.dequeue(LaunchDetailsCell.self, indexPath: indexPath)
            cell.configure(with: vm)
            return cell

        case .loading:
            let cell = collectionView.dequeue(LoadingCell.self, indexPath: indexPath)
            cell.startAnimating()
            return cell

        case .rocket(let vm):
            let cell = collectionView.dequeue(RocketDetailsCell.self, indexPath: indexPath)
            cell.configure(with: vm)
            return cell

        case .button(let vm):
            let cell = collectionView.dequeue(ButtonCell.self, indexPath: indexPath)
            cell.configure(viewModel: vm)
            return cell

        }
    })

    private var bag = DisposeBag()

    init(viewModel: LaunchDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        title = viewModel.title
    }

    private func setupCollectionView() {
        collectionView.registerNib(ImagesCarouselCell.self)
        collectionView.registerNib(LaunchDetailsCell.self)
        collectionView.registerNib(LoadingCell.self)
        collectionView.registerNib(RocketDetailsCell.self)
        collectionView.registerNib(TextCell.self)
        collectionView.registerNib(ButtonCell.self)

        collectionView.rx.setDelegate(self).disposed(by: bag)

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.setCollectionViewLayout(layout, animated: false)

        viewModel.data
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        collectionView.rx.modelSelected(LaunchDetailsViewModel.ItemType.self)
            .subscribe(onNext: { model in
                switch model {
                case .button(let vm):
                    vm.action()
                default:
                    break
                }
            })
            .disposed(by: bag)
    }

}

extension LaunchDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.width
        let padding: CGFloat = 16
        let item = dataSource[indexPath.section].items[indexPath.item]

        switch item {

        case .imagesCarousel:
            return CGSize(width: width, height: 200)

        case .text(let vm):
            let width = width - padding * 2
            let height = TextCell.height(with: width, viewModel: vm) + padding
            return CGSize(width: width, height: height)

        case .details(let vm):
            return CGSize(width: width, height: LaunchDetailsCell.height(with: width, viewModel: vm))

        case .loading:
            return CGSize(width: width, height: 100)

        case .rocket(let rocket):
            return CGSize(width: width, height: 400)

        case .button:
            return CGSize(width: width, height: 66)

        }

    }

}

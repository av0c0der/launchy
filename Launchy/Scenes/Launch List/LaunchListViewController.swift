//
//
//  Launchy
//  
//  Created on 27.02.2021
//  
//  

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

/// Displays list of vertically stacked launches providing a brief inromation about each of them.
final class LaunchListViewController: UIViewController {

    private let flowLayout = UICollectionViewFlowLayout()

    private let viewModel: LaunchListViewModel

    init(viewModel: LaunchListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet private weak var collectionView: UICollectionView!

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<LaunchListViewModel.Section>(configureCell: { [unowned self] (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
        switch item {

        case .launchItem(let vm):
            let cell = collectionView.dequeue(LaunchListItemCell.self, indexPath: indexPath)
            cell.configure(with: vm)
            return cell

        case .text(let vm):
            let cell = collectionView.dequeue(TextCell.self, indexPath: indexPath)
            cell.configure(with: vm)
            return cell

        case .loading:
            let cell = collectionView.dequeue(LoadingCell.self, indexPath: indexPath)
            cell.startAnimating()
            return cell

        }
    })

    private var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .secondarySystemBackground
        title = "Launchy 🚀"
        navigationItem.largeTitleDisplayMode = .always
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.registerNib(LaunchListItemCell.self)
        collectionView.registerNib(TextCell.self)
        collectionView.registerNib(LoadingCell.self)
        collectionView.rx.setDelegate(self).disposed(by: bag)

        let padding: CGFloat = 16
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: padding, bottom: 20, right: padding)

        collectionView.setCollectionViewLayout(flowLayout, animated: false)

        viewModel.data
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        collectionView.rx
            .modelSelected(LaunchListViewModel.Item.self)
            .subscribe(onNext: { [unowned self] item in
                self.viewModel.handleSelection(item)
            })
            .disposed(by: bag)
    }

}

extension LaunchListViewController: UICollectionViewDelegateFlowLayout {

    // MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = collectionView.contentInset
        let width = collectionView.bounds.width - inset.left - inset.right - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let item = dataSource[indexPath.section].items[indexPath.item]

        switch item {
        case .launchItem(let vm):
            let height = LaunchListItemCell.height(with: width, viewModel: vm)
            return CGSize(width: width, height: height)

        case .text(let vm):
            let height = TextCell.height(with: width, viewModel: vm)
            return CGSize(width: width, height: height)

        case .loading:
            return CGSize(width: width, height: 100)
        }

    }

}

//
//
//  Launchy
//  
//  Created on 28.02.2021
//  
//  

import UIKit
import RxFlow
import RxSwift
import SafariServices

enum LaunchStep: Step {
    case list
    case details(_ launch: Launch)
    case link(URL?)
}

final class LaunchesFlow: Flow {

    var root: Presentable { rootViewController }

    private let rootViewController = UINavigationController()
    private let dependencyContainer: DependencyContainer

    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        rootViewController.navigationBar.prefersLargeTitles = true
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let launchStep = step as? LaunchStep else {
            return .none
        }

        switch launchStep {
        case .list:

            let viewModel = LaunchListViewModel(launchesService: dependencyContainer.makeLaunchesService())
            let viewController = LaunchListViewController(viewModel: viewModel)
            rootViewController.show(viewController, sender: self)
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))

        case .details(let launch):

            let viewModel = LaunchDetailsViewModel(launchesService: dependencyContainer.makeLaunchesService(), rocketsService: dependencyContainer.makeRocketsService(), launch: launch)
            let viewController = LaunchDetailsViewController(viewModel: viewModel)
            rootViewController.show(viewController, sender: self)
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))

        case .link(let link):
            guard let url = link else {
                return .none
            }

            UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { [unowned self] success in
                guard success == false else {
                    return
                }
                let safariViewController = SFSafariViewController(url: url)
                self.rootViewController.present(safariViewController, animated: true)
            }

            return .none

        }
    }

}

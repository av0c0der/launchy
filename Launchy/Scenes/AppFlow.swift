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
import RxRelay

enum AppStep: Step {
    case launches
}

final class AppFlow: Flow {

    var root: Presentable {
        window
    }

    private let window: UIWindow
    private let dependencyContainer: DependencyContainer

    init(window: UIWindow, dependencyContainer: DependencyContainer) {
        self.window = window
        self.dependencyContainer = dependencyContainer
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let appStep = step as? AppStep else { return .none }

        switch appStep {

        case .launches:
            let launchesFlow = LaunchesFlow(dependencyContainer: dependencyContainer)
            Flows.use(launchesFlow, when: .created) { [unowned self] root in
                DispatchQueue.main.async {
                    self.window.rootViewController = root
                }
            }

            return .one(flowContributor: .contribute(
                            withNextPresentable: launchesFlow,
                            withNextStepper: OneStepper(withSingleStep: LaunchStep.list)))

        }
    }

}

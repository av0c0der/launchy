//
//
//  Launchy
//  
//  Created on 27.02.2021
//  
//  

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxFlow

struct LaunchListViewModel: Stepper {

    let steps = PublishRelay<Step>()

    enum Item {
        case text(TextCellViewModel)
        case launchItem(LaunchListItemViewModel)
        case loading
    }

    typealias Section = SectionModel<String, Item>

    var data: Observable<[Section]> {
        return items.asObservable()
    }

    private let items = BehaviorRelay<[Section]>(value: [
        .init(model: "loading", items: [.loading])
    ])

    private var bag = DisposeBag()

    private let pageLimit = 100

    init(launchesService service: LaunchesService) {
        let now = Date()
        let minDate = Calendar.current.date(byAdding: .year, value: -3, to: now)!

        let sorting: [LaunchesSorting] = [
            .init(type: .date, ascending: false),
            .init(type: .upcoming, ascending: false),
        ]

        let upcomingLaunches = service.fetchLaunches(minDate: nil, maxDate: nil, limit: 1000, page: 1, sorting: sorting, upcoming: true)
            .catchAndReturn([])
            .asObservable()
        let completedLaunches = service.fetchLaunches(minDate: minDate, maxDate: nil, limit: pageLimit, page: 1, sorting: sorting, upcoming: nil)
            .catchAndReturn([])
            .asObservable()

        let upcomingSection = getLaunchesSection(upcomingLaunches, header: "UPCOMING LAUNCHES")
        let completedSection = getLaunchesSection(completedLaunches, header: "COMPLETED LAUNCHES")

        Observable.zip(upcomingSection, completedSection, resultSelector: { [$0, $1] })
            .asDriver(onErrorJustReturn: [])
            .drive(items)
            .disposed(by: bag)
    }

    private func getLaunchesSection(_ launches: Observable<[Launch]>, header: String) -> Observable<Section> {
        return launches.map { items in
            let launchItems = items
                .map(LaunchListItemViewModel.init(from:))
                .map(Item.launchItem)
            let upcomingSection = Section(model: header, items: [.text(.header(header))] + launchItems)
            return upcomingSection
        }
    }

    func handleSelection(_ item: Item) {
        switch item {
        case .launchItem(let vm):
            steps.accept(LaunchStep.details(vm.launch))
        default:
            break
        }
    }

}

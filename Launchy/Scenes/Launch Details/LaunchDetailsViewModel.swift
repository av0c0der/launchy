//
//
//  Launchy
//  
//  Created on 28.02.2021
//  
//  

import Foundation
import RxSwift
import RxDataSources
import RxFlow
import RxRelay

final class LaunchDetailsViewModel: Stepper {

    enum ItemType: Equatable {
        case imagesCarousel(ImagesCarouselCellViewModel)
        case text(TextCellViewModel)
        case details(LaunchListItemViewModel)
        case rocket(Rocket)
        case loading
        case button(ButtonCellViewModel)
    }

    typealias Section = SectionModel<String, ItemType>

    let steps = PublishRelay<Step>()

    let title: String

    var data: Observable<[Section]> {
        return items.asObservable()
    }

    private let items = BehaviorRelay<[Section]>(value: [])
    private var bag = DisposeBag()
    private let launchesService: LaunchesService
    private let rocketsService: RocketsService
    private let launch: Launch

    init(launchesService: LaunchesService, rocketsService: RocketsService, launch: Launch) {
        self.launchesService = launchesService
        self.rocketsService = rocketsService
        self.launch = launch

        title = "Launch #\(launch.number)"

        let launchItemViewModel = LaunchListItemViewModel(from: launch)

        let launchItems: [ItemType] = [
            .text(.title("Mission info")),
            launch.largeImageURLs.isEmpty ? nil : .imagesCarousel(launch.largeImageURLs),
            .details(launchItemViewModel),
            .text(.header(launch.name)),
            launch.details.flatMap {
                ItemType.text(.body($0))
            },
            launch.links.webcast.flatMap { link in
                ItemType.button(ButtonCellViewModel(symbolName: "play.rectangle", text: "Watch webcast", action: { [unowned self] in
                    self.steps.accept(LaunchStep.link(link))
                }))
            },
            launch.links.wikipedia.flatMap { link in
                .button(ButtonCellViewModel(symbolName: "books.vertical", text: "Read on Wikipedia", action: { [unowned self] in
                    self.steps.accept(LaunchStep.link(link))
                }))
            },
            launch.links.presskit.flatMap { link in
                ItemType.button(ButtonCellViewModel(symbolName: "quote.bubble", text: "Read press kit", action: { [unowned self] in
                    self.steps.accept(LaunchStep.link(link))
                }))
            },
            launch.links.article.flatMap { link in
                ItemType.button(ButtonCellViewModel(symbolName: "newspaper", text: "Read article", action: { [unowned self] in
                    self.steps.accept(LaunchStep.link(link))
                }))
            }
        ]
        .compactMap { $0 }
        let launchSection = Observable.just(Section(model: "launch-info", items: launchItems))

        let rocketSection = rocketsService.getRocket(id: launch.rocket)
            .asObservable()
            .map { rocket -> [ItemType] in
                [
                    .imagesCarousel(rocket.flickr_images),
                    .text(.body(rocket.description)),
                    .button(ButtonCellViewModel(symbolName: "books.vertical", text: "Read on Wikipedia", action: { [unowned self] in
                        self.steps.accept(LaunchStep.link(rocket.wikipedia))
                    }))
                ]
            }
            .asObservable()
            .startWith([.loading])
            .map { items in
                return Section(
                    model: "rocket-info",
                    items: [.text(.title("Rocket"))] + items
                )
            }

        Observable.combineLatest(
            launchSection,
            rocketSection
        )
        .map { [$0, $1] }
        .bind(to: items)
        .disposed(by: bag)
    }

}

//
//
//  Launchy
//  
//  Created on 27.02.2021
//  
//  

import Foundation

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    return dateFormatter
}()

struct LaunchListItemViewModel: Equatable {
    let launch: Launch
    let number: String
    let title: String
    let date: String
    let description: String?
    let imageURL: URL?
    let isUpcoming: Bool
}

extension LaunchListItemViewModel {
    init(from launch: Launch) {
        let format: String
        switch launch.datePrecision {
        case .hour:
            format = "HH:mm dd/MMMM/yyyy"
        case .day:
            format = "dd/MMMM/yyyy"
        case .month:
            format = "MMMM/yyyy"
        case .quarter, .half, .year:
            format = "yyyy"
        }
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: Locale.current)

        self.init(
            launch: launch,
            number: "#" + String(launch.number),
            title: launch.name,
            date: dateFormatter.string(from: launch.launchDate),
            description: launch.details,
            imageURL: launch.largeImageURL,
            isUpcoming: launch.upcoming
        )
    }
}

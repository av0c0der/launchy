//
//
//  LaunchyTests
//  
//  Created on 01.03.2021
//  
//  

import XCTest
@testable import Launchy

class LaunchListItemViewModelTests: XCTestCase {

    var hourPrecisionLaunchVM: LaunchListItemViewModel!
    var dayPrecisionLaunchVM: LaunchListItemViewModel!
    var monthPrecisionLaunchVM: LaunchListItemViewModel!
    var yearPrecisionLaunchVM: LaunchListItemViewModel!

    private func createLaunch(with id: String, number: Int, date: Date, datePrecision: Launch.DatePrecision, upcoming: Bool) -> Launch {
        Launch(id: id, number: number, name: UUID().uuidString, details: nil, rocket: UUID().uuidString, launchDate: date, datePrecision: datePrecision, upcoming: upcoming, links: .init(flickr: .init(small: [], original: []), presskit: nil, webcast: nil, article: nil, wikipedia: nil))
    }

    override func setUpWithError() throws {
        let hourPrecisionLaunch = createLaunch(with: "xyz789", number: 111, date: Calendar.current.date(byAdding: .year, value: 2, to: Date())!, datePrecision: .hour, upcoming: true)
        hourPrecisionLaunchVM = .init(from: hourPrecisionLaunch)

        let dayPrecisionLaunch = createLaunch(with: "def456", number: 120, date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!, datePrecision: .day, upcoming: true)
        dayPrecisionLaunchVM = .init(from: dayPrecisionLaunch)

        let monthPrecisionLaunch = createLaunch(with: "abc123", number: 100, date: Calendar.current.date(byAdding: .month, value: 5, to: Date())!, datePrecision: .month, upcoming: true)
        monthPrecisionLaunchVM = LaunchListItemViewModel(from: monthPrecisionLaunch)

        let yearPrecisionLaunch = createLaunch(with: "qwe567", number: 110, date: Calendar.current.date(byAdding: .year, value: 10, to: Date())!, datePrecision: .year, upcoming: true)
        yearPrecisionLaunchVM = .init(from: yearPrecisionLaunch)
    }

    func testDateIsCorrectlyFormattedForHourDatePrecision() {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm dd/MMMM/yyyy")
        XCTAssertEqual(dateFormatter.string(from: hourPrecisionLaunchVM.launch.launchDate), hourPrecisionLaunchVM.date)
    }

    func testDateIsCorrectlyFormattedForDayDatePrecision() {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd/MMMM/yyyy")
        XCTAssertEqual(dateFormatter.string(from: dayPrecisionLaunchVM.launch.launchDate), dayPrecisionLaunchVM.date)
    }

    func testDateIsCorrectlyFormattedForMonthDatePrecision() {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM/yyyy")
        XCTAssertEqual(dateFormatter.string(from: monthPrecisionLaunchVM.launch.launchDate), monthPrecisionLaunchVM.date)
    }

    func testDateIsCorrectlyFormattedForYearDatePrecision() {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy")
        XCTAssertEqual(dateFormatter.string(from: yearPrecisionLaunchVM.launch.launchDate), yearPrecisionLaunchVM.date)
    }

}

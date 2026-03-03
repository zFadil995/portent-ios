import XCTest
@testable import Portent

@MainActor
final class TabDestinationTests: XCTestCase {
    func test_allFourCasesExistInCaseIterableOrder() {
        let expected: [TabDestination] = [.dashboard, .calendar, .services, .search]
        XCTAssertEqual(Array(TabDestination.allCases), expected)
    }

    func test_everyCaseHasNonEmptyLabel() {
        XCTAssertTrue(TabDestination.allCases.allSatisfy { !$0.label.isEmpty })
    }

    func test_everyCaseHasNonEmptySystemImage() {
        XCTAssertTrue(TabDestination.allCases.allSatisfy { !$0.systemImage.isEmpty })
    }

    func test_idEqualsRawValue() {
        for tab in TabDestination.allCases {
            XCTAssertEqual(tab.id, tab.rawValue)
        }
    }
}

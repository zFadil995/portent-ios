import XCTest
@testable import Portent

@MainActor
final class AppSettingsStorageTests: XCTestCase {
    private var store: FakeSecureStore!
    private var storage: AppSettingsStorage!

    override func setUp() {
        super.setUp()
        store = FakeSecureStore()
        storage = AppSettingsStorage(store: store)
    }

    func test_analyticsOptIn_defaultsToFalse() {
        XCTAssertFalse(storage.analyticsOptIn)
    }

    func test_analyticsOptIn_writeTrue_readBackTrue() {
        storage.analyticsOptIn = true
        XCTAssertTrue(storage.analyticsOptIn)
    }

    func test_onboardingComplete_defaultsToFalse() {
        XCTAssertFalse(storage.onboardingComplete)
    }

    func test_clearAll_removesAllAppSettingsKeys() {
        storage.analyticsOptIn = true
        storage.onboardingComplete = true
        storage.theme = "dark"

        storage.clearAll()

        XCTAssertFalse(storage.analyticsOptIn)
        XCTAssertFalse(storage.onboardingComplete)
        XCTAssertEqual(storage.theme, "system")
    }
}

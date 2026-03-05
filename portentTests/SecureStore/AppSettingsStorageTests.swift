import XCTest
@testable import Portent

@MainActor
final class AppSettingsStorageTests: XCTestCase {
    private var store: FakeSecureStore?
    private var storage: AppSettingsStorage?

    override func setUp() async throws {
        try await super.setUp()
        let fakeStore = FakeSecureStore()
        store = fakeStore
        storage = AppSettingsStorage(store: fakeStore)
    }

    func test_analyticsOptIn_defaultsToFalse() throws {
        let storage = try XCTUnwrap(storage)
        XCTAssertFalse(storage.analyticsOptIn)
    }

    func test_analyticsOptIn_writeTrue_readBackTrue() throws {
        let storage = try XCTUnwrap(storage)
        storage.analyticsOptIn = true
        XCTAssertTrue(storage.analyticsOptIn)
    }

    func test_onboardingComplete_defaultsToFalse() throws {
        let storage = try XCTUnwrap(storage)
        XCTAssertFalse(storage.onboardingComplete)
    }

    func test_clearAll_removesAllAppSettingsKeys() throws {
        let storage = try XCTUnwrap(storage)
        storage.analyticsOptIn = true
        storage.onboardingComplete = true
        storage.theme = "dark"

        storage.clearAll()

        XCTAssertFalse(storage.analyticsOptIn)
        XCTAssertFalse(storage.onboardingComplete)
        XCTAssertEqual(storage.theme, "system")
    }
}

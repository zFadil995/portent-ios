import XCTest
@testable import Portent

@MainActor
final class SonarrSecureStorageTests: XCTestCase {
    private var store: FakeSecureStore?
    private var storage: SonarrSecureStorage?

    override func setUp() async throws {
        try await super.setUp()
        let fakeStore = FakeSecureStore()
        store = fakeStore
        storage = SonarrSecureStorage(store: fakeStore)
    }

    func test_writeBaseUrl_readBack_equal() throws {
        let storage = try XCTUnwrap(storage)
        storage.baseUrl = "https://sonarr.example.com"
        XCTAssertEqual(storage.baseUrl, "https://sonarr.example.com")
    }

    func test_writeApiKey_readBack_equal() throws {
        let storage = try XCTUnwrap(storage)
        storage.apiKey = "secret-key-123"
        XCTAssertEqual(storage.apiKey, "secret-key-123")
    }

    func test_isConfigured_returnsFalse_whenEmpty() throws {
        let storage = try XCTUnwrap(storage)
        XCTAssertFalse(storage.isConfigured)
        storage.baseUrl = "https://sonarr.local"
        XCTAssertFalse(storage.isConfigured)
        storage.apiKey = "key"
        XCTAssertTrue(storage.isConfigured)
    }

    func test_clear_removesAllValues_returnsDefaults() throws {
        let storage = try XCTUnwrap(storage)
        storage.baseUrl = "https://example.com"
        storage.apiKey = "key"

        storage.clear()

        XCTAssertEqual(storage.baseUrl, "")
        XCTAssertEqual(storage.apiKey, "")
        XCTAssertEqual(storage.name, "Sonarr")
        XCTAssertFalse(storage.ignoreSslErrors)
        XCTAssertTrue(storage.isSearchable)
    }
}

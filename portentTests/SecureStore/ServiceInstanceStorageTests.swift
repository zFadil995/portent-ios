import XCTest
@testable import Portent

@MainActor
final class ServiceInstanceStorageTests: XCTestCase {
    private var store: FakeSecureStore?
    private var storage: ServiceInstanceStorage?

    override func setUp() async throws {
        try await super.setUp()
        let fakeStore = FakeSecureStore()
        store = fakeStore
        storage = ServiceInstanceStorage(store: fakeStore)
    }

    func test_writeBaseUrl_readBack_equal() throws {
        let storage = try XCTUnwrap(storage)
        let id = UUID()
        storage.setBaseUrl(id: id, value: "https://radarr.example.com")
        XCTAssertEqual(storage.getBaseUrl(id: id), "https://radarr.example.com")
    }

    func test_writeApiKey_readBack_equal() throws {
        let storage = try XCTUnwrap(storage)
        let id = UUID()
        storage.setApiKey(id: id, value: "secret-key-123")
        XCTAssertEqual(storage.getApiKey(id: id), "secret-key-123")
    }

    func test_isDefault_defaultsToFalse_whenNotSet() throws {
        let storage = try XCTUnwrap(storage)
        let id = UUID()
        XCTAssertFalse(storage.getIsDefault(id: id))
    }

    func test_clearAll_removesAllServiceInstanceKeys_returnsDefaults() throws {
        let storage = try XCTUnwrap(storage)
        let id = UUID()
        storage.setBaseUrl(id: id, value: "https://example.com")
        storage.setApiKey(id: id, value: "key")
        storage.instanceIds = [id.uuidString]

        storage.clearAll()

        XCTAssertEqual(storage.getBaseUrl(id: id), "")
        XCTAssertEqual(storage.getApiKey(id: id), "")
        XCTAssertTrue(storage.instanceIds.isEmpty)
    }
}

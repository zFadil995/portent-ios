import XCTest
@testable import Portent

@MainActor
final class ServiceInstanceStorageTests: XCTestCase {

    // MARK: - Radarr

    func test_radarr_writeBaseUrl_readBack_equal() throws {
        asyncTest {
            let storage = ServiceInstanceStorage(type: .radarr, store: FakeSecureStore())
            storage.baseUrl = "https://radarr.example.com"
            XCTAssertEqual(storage.baseUrl, "https://radarr.example.com")
        }
    }

    func test_radarr_writeApiKey_readBack_equal() throws {
        asyncTest {
            let storage = ServiceInstanceStorage(type: .radarr, store: FakeSecureStore())
            storage.apiKey = "secret-key-123"
            XCTAssertEqual(storage.apiKey, "secret-key-123")
        }
    }

    func test_radarr_writeName_readBack_equal() throws {
        asyncTest {
            let storage = ServiceInstanceStorage(type: .radarr, store: FakeSecureStore())
            storage.name = "Home Movies"
            XCTAssertEqual(storage.name, "Home Movies")
        }
    }

    func test_radarr_isConfigured_returnsFalse_whenEmpty() throws {
        asyncTest {
            let storage = ServiceInstanceStorage(type: .radarr, store: FakeSecureStore())
            XCTAssertFalse(storage.isConfigured)
            storage.baseUrl = "https://radarr.local"
            XCTAssertFalse(storage.isConfigured)
            storage.apiKey = "key"
            XCTAssertTrue(storage.isConfigured)
        }
    }

    func test_radarr_clear_removesAllValues_returnsEmptyDefaults() throws {
        asyncTest {
            let storage = ServiceInstanceStorage(type: .radarr, store: FakeSecureStore())
            storage.baseUrl = "https://example.com"
            storage.apiKey = "key"
            storage.name = "Home Movies"

            storage.clear()

            XCTAssertEqual(storage.baseUrl, "")
            XCTAssertEqual(storage.apiKey, "")
            XCTAssertEqual(storage.name, "")
            XCTAssertFalse(storage.ignoreSslErrors)
            XCTAssertTrue(storage.isSearchable)
        }
    }

    // MARK: - Sonarr

    func test_sonarr_writeBaseUrl_readBack_equal() throws {
        asyncTest {
            let storage = ServiceInstanceStorage(type: .sonarr, store: FakeSecureStore())
            storage.baseUrl = "https://sonarr.example.com"
            XCTAssertEqual(storage.baseUrl, "https://sonarr.example.com")
        }
    }

    func test_sonarr_writeApiKey_readBack_equal() throws {
        asyncTest {
            let storage = ServiceInstanceStorage(type: .sonarr, store: FakeSecureStore())
            storage.apiKey = "secret-key-456"
            XCTAssertEqual(storage.apiKey, "secret-key-456")
        }
    }

    func test_sonarr_isConfigured_returnsFalse_whenEmpty() throws {
        asyncTest {
            let storage = ServiceInstanceStorage(type: .sonarr, store: FakeSecureStore())
            XCTAssertFalse(storage.isConfigured)
            storage.baseUrl = "https://sonarr.local"
            XCTAssertFalse(storage.isConfigured)
            storage.apiKey = "key"
            XCTAssertTrue(storage.isConfigured)
        }
    }

    func test_sonarr_clear_removesAllValues_returnsEmptyDefaults() throws {
        asyncTest {
            let storage = ServiceInstanceStorage(type: .sonarr, store: FakeSecureStore())
            storage.baseUrl = "https://example.com"
            storage.apiKey = "key"
            storage.name = "My Shows"

            storage.clear()

            XCTAssertEqual(storage.baseUrl, "")
            XCTAssertEqual(storage.apiKey, "")
            XCTAssertEqual(storage.name, "")
            XCTAssertFalse(storage.ignoreSslErrors)
            XCTAssertTrue(storage.isSearchable)
        }
    }

    // MARK: - Domain isolation

    func test_radarrAndSonarr_storageIsolated() throws {
        asyncTest {
            let radarrStore = FakeSecureStore()
            let sonarrStore = FakeSecureStore()
            let radarr = ServiceInstanceStorage(type: .radarr, store: radarrStore)
            let sonarr = ServiceInstanceStorage(type: .sonarr, store: sonarrStore)

            radarr.baseUrl = "https://radarr.local"
            sonarr.baseUrl = "https://sonarr.local"

            XCTAssertEqual(radarr.baseUrl, "https://radarr.local")
            XCTAssertEqual(sonarr.baseUrl, "https://sonarr.local")
            XCTAssertNotEqual(radarr.baseUrl, sonarr.baseUrl)
        }
    }

    func test_type_isStoredOnInstance() throws {
        asyncTest {
            let radarr = ServiceInstanceStorage(type: .radarr, store: FakeSecureStore())
            let sonarr = ServiceInstanceStorage(type: .sonarr, store: FakeSecureStore())
            XCTAssertEqual(radarr.type, .radarr)
            XCTAssertEqual(sonarr.type, .sonarr)
        }
    }

    // MARK: - onChanged callback

    func test_clear_invokesOnChangedCallback() throws {
        asyncTest {
            let storage = ServiceInstanceStorage(type: .radarr, store: FakeSecureStore())
            var callbackCount = 0
            storage.onChanged = { callbackCount += 1 }

            storage.clear()

            XCTAssertEqual(callbackCount, 1)
        }
    }
}

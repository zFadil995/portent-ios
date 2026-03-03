// Keychain integration tests. Requires real Keychain (device or simulator).
// Can be excluded from fast unit test runs if needed.
//
// Flaky risk: uses real Keychain. May fail under parallel execution or simulator state.
// Consider test isolation (e.g. unique key prefix per run) in a follow-up.

import XCTest
@testable import Portent

@MainActor
final class SecureStoreKeychainIntegrationTests: XCTestCase {
    private var store: SecureStore { SecureStore.shared }
    private let testPrefix = "test_integration_"

    override func tearDown() {
        try? store.clearAll(prefix: testPrefix)
        super.tearDown()
    }

    func test_write_read_roundtrip() throws {
        let key = testPrefix + "key1"
        let value = "test-value-123"
        try store.write(key: key, value: value)
        let read = try store.read(key: key)
        XCTAssertEqual(read, value)
    }

    func test_overwrite_returnsNewValue() throws {
        let key = testPrefix + "key2"
        try store.write(key: key, value: "old")
        try store.write(key: key, value: "new")
        let read = try store.read(key: key)
        XCTAssertEqual(read, "new")
    }

    func test_delete_readReturnsNil() throws {
        let key = testPrefix + "key3"
        try store.write(key: key, value: "to-delete")
        try store.delete(key: key)
        let read = try store.read(key: key)
        XCTAssertNil(read)
    }

    func test_clearAll_withPrefix_onlyRemovesMatchingKeys() throws {
        let keyA = testPrefix + "keyA"
        let keyB = testPrefix + "keyB"
        let keyOther = testPrefix + "other_domain_key"

        try store.write(key: keyA, value: "a")
        try store.write(key: keyB, value: "b")
        try store.write(key: keyOther, value: "other")

        try store.clearAll(prefix: testPrefix + "key")

        XCTAssertNil(try store.read(key: keyA))
        XCTAssertNil(try store.read(key: keyB))
        XCTAssertEqual(try store.read(key: keyOther), "other")
    }
}

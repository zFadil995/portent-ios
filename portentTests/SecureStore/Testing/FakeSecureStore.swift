// In-memory dictionary-backed fake for unit tests. No Keychain access.

import Foundation
@testable import Portent

final class FakeSecureStore: SecureStoreProtocol, @unchecked Sendable {
    private var storage: [String: String] = [:]

    func write(key: String, value: String) throws {
        storage[key] = value
    }

    func read(key: String) throws -> String? {
        storage[key]
    }

    func delete(key: String) throws {
        storage.removeValue(forKey: key)
    }

    func contains(key: String) -> Bool {
        storage[key] != nil
    }

    func clearAll(prefix: String) throws {
        for key in storage.keys where key.hasPrefix(prefix) {
            storage.removeValue(forKey: key)
        }
    }

    func clear() {
        storage.removeAll()
    }

    var count: Int { storage.count }
}

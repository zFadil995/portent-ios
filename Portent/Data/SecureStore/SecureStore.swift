//
//  SecureStore.swift
//  portent
//
//  Single entry point for all Keychain access. Uses kSecClassGenericPassword
//  with kSecAttrAccessibleAfterFirstUnlock (no iCloud sync).
//

import Foundation
import Security

/// Protocol for Keychain-like storage. Enables injection of FakeSecureStore in tests.
protocol SecureStoreProtocol: AnyObject {
    func write(key: String, value: String) throws
    func read(key: String) throws -> String?
    func delete(key: String) throws
    func contains(key: String) -> Bool
    func clearAll(prefix: String) throws
}

final class SecureStore: SecureStoreProtocol {
    static let shared = SecureStore()

    private let serviceName: String
    private let queue = DispatchQueue(label: "com.notitial.portent.securestore", qos: .userInitiated)

    private init(serviceName: String = "com.notitial.portent.secure_store") {
        self.serviceName = serviceName
    }

    func write(key: String, value: String) throws {
        try queue.sync {
            let data = value.data(using: .utf8) ?? Data()
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: key
            ]
            let attributes: [String: Any] = [
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
            ]

            var status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

            if status == errSecItemNotFound {
                var addQuery = query
                addQuery[kSecValueData as String] = data
                addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
                status = SecItemAdd(addQuery as CFDictionary, nil)
            }

            if status != errSecSuccess {
                throw SecureStoreError.writeFailed(status)
            }
        }
    }

    func read(key: String) throws -> String? {
        try queue.sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: key,
                kSecReturnData as String: true,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]

            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)

            if status == errSecItemNotFound {
                return nil
            }
            if status != errSecSuccess {
                throw SecureStoreError.readFailed(status)
            }

            guard let data = result as? Data,
                  let string = String(data: data, encoding: .utf8)
            else {
                throw SecureStoreError.dataCorrupted
            }
            return string
        }
    }

    func delete(key: String) throws {
        try queue.sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: key
            ]

            let status = SecItemDelete(query as CFDictionary)
            if status != errSecSuccess && status != errSecItemNotFound {
                throw SecureStoreError.deleteFailed(status)
            }
        }
    }

    func contains(key: String) -> Bool {
        queue.sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: key,
                kSecReturnData as String: false,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]

            let status = SecItemCopyMatching(query as CFDictionary, nil)
            return status == errSecSuccess
        }
    }

    func clearAll(prefix: String) throws {
        try queue.sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecReturnAttributes as String: true,
                kSecMatchLimit as String: kSecMatchLimitAll
            ]

            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)

            if status == errSecItemNotFound {
                return
            }
            if status != errSecSuccess {
                throw SecureStoreError.readFailed(status)
            }

            guard let items = result as? [[String: Any]] else {
                return
            }

            for item in items {
                guard let account = item[kSecAttrAccount as String] as? String,
                      account.hasPrefix(prefix)
                else { continue }

                let deleteQuery: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrService as String: serviceName,
                    kSecAttrAccount as String: account
                ]
                let deleteStatus = SecItemDelete(deleteQuery as CFDictionary)
                if deleteStatus != errSecSuccess && deleteStatus != errSecItemNotFound {
                    throw SecureStoreError.deleteFailed(deleteStatus)
                }
            }
        }
    }
}

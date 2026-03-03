//
//  SecureStorage.swift
//  portent
//
//  Abstract base for domain-scoped storage. Keys are prefixed as "{domain}__{key}"
//  to match Android convention. All operations delegate to SecureStore.
//

import Foundation

open class SecureStorage {
    let domain: String
    private let store: SecureStoreProtocol

    init(domain: String, store: SecureStoreProtocol) {
        precondition(!domain.isEmpty, "Storage domain cannot be blank")
        self.domain = domain
        self.store = store
    }

    convenience init(domain: String) {
        self.init(domain: domain, store: SecureStore.shared)
    }

    private func storageKey(for key: String) -> String {
        "\(domain)__\(key)"
    }

    func read(key: String, default defaultValue: String) -> String {
        let sk = storageKey(for: key)
        return (try? store.read(key: sk)) ?? defaultValue
    }

    func write(key: String, value: String) {
        let sk = storageKey(for: key)
        try? store.write(key: sk, value: value)
    }

    func readBool(key: String, default defaultValue: Bool) -> Bool {
        let raw = read(key: key, default: defaultValue ? "true" : "false")
        return raw == "true"
    }

    func writeBool(key: String, value: Bool) {
        write(key: key, value: value ? "true" : "false")
    }

    func readInt(key: String, default defaultValue: Int) -> Int {
        let raw = read(key: key, default: String(defaultValue))
        return Int(raw) ?? defaultValue
    }

    func writeInt(key: String, value: Int) {
        write(key: key, value: String(value))
    }

    func remove(key: String) {
        let sk = storageKey(for: key)
        try? store.delete(key: sk)
    }

    func contains(key: String) -> Bool {
        store.contains(key: storageKey(for: key))
    }

    func clearAll() {
        try? store.clearAll(prefix: "\(domain)__")
    }
}

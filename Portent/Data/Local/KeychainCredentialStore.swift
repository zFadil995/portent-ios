//
//  KeychainCredentialStore.swift
//  portent
//

import Foundation

private let keychainService = "com.notitial.portent"
private let instanceKeyPrefix = "portent.instance."
private let indexKey = "portent.instance.index"

/// Codable DTO for Keychain storage. Domain ServiceInstance is not modified.
/// Uses String for type to avoid Codable conformance in domain.
private struct ServiceInstanceDTO: Codable {
    let id: UUID
    let typeRaw: String
    let name: String
    let baseUrl: String
    let apiKey: String
    let isDefault: Bool
    let ignoreSslErrors: Bool
    let isSearchable: Bool

    init(from instance: ServiceInstance) {
        id = instance.id
        typeRaw = instance.type.rawValue
        name = instance.name
        baseUrl = instance.baseUrl
        apiKey = instance.apiKey
        isDefault = instance.isDefault
        ignoreSslErrors = instance.ignoreSslErrors
        isSearchable = instance.isSearchable
    }

    func toInstance() -> ServiceInstance {
        let type = ServiceType(rawValue: typeRaw) ?? .radarr
        return ServiceInstance(
            id: id,
            type: type,
            name: name,
            baseUrl: baseUrl,
            apiKey: apiKey,
            isDefault: isDefault,
            ignoreSslErrors: ignoreSslErrors,
            isSearchable: isSearchable
        )
    }
}

final class KeychainCredentialStore: CredentialStore {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func saveInstance(_ instance: ServiceInstance) async throws {
        let dto = ServiceInstanceDTO(from: instance)
        let data = try encoder.encode(dto)
        let key = instanceKeyPrefix + instance.id.uuidString

        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        var status = SecItemAdd(addQuery as CFDictionary, nil)

        if status == errSecDuplicateItem {
            let deleteQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: keychainService,
                kSecAttrAccount as String: key
            ]
            SecItemDelete(deleteQuery as CFDictionary)
            status = SecItemAdd(addQuery as CFDictionary, nil)
        }

        if status != errSecSuccess {
            throw AppError.local(.unknown)
        }

        try await updateIndex { ids in
            var set = Set(ids)
            set.insert(instance.id)
            return Array(set)
        }
    }

    func getInstances() async throws -> [ServiceInstance] {
        let ids = try await loadIndex()
        var instances: [ServiceInstance] = []
        for id in ids {
            if let instance = try await getInstanceById(id) {
                instances.append(instance)
            }
        }
        return instances
    }

    func getInstanceById(_ id: UUID) async throws -> ServiceInstance? {
        let key = instanceKeyPrefix + id.uuidString
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
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
            throw AppError.local(.unknown)
        }

        guard let data = result as? Data else {
            throw AppError.local(.unknown)
        }

        let dto = try decoder.decode(ServiceInstanceDTO.self, from: data)
        return dto.toInstance()
    }

    func deleteInstance(id: UUID) async throws {
        let key = instanceKeyPrefix + id.uuidString
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw AppError.local(.unknown)
        }

        try await updateIndex { ids in ids.filter { $0 != id } }
    }

    func updateInstance(_ instance: ServiceInstance) async throws {
        let dto = ServiceInstanceDTO(from: instance)
        let data = try encoder.encode(dto)
        let key = instanceKeyPrefix + instance.id.uuidString

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key
        ]

        let attributes: [String: Any] = [kSecValueData as String: data]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        if status == errSecItemNotFound {
            try await saveInstance(instance)
            return
        }
        if status != errSecSuccess {
            throw AppError.local(.unknown)
        }
    }

    private func loadIndex() async throws -> [UUID] {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: indexKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecItemNotFound {
            return []
        }
        if status != errSecSuccess {
            throw AppError.local(.unknown)
        }

        guard let data = result as? Data,
              let strings = try? JSONDecoder().decode([String].self, from: data)
        else {
            throw AppError.local(.unknown)
        }

        return strings.compactMap { UUID(uuidString: $0) }
    }

    private func updateIndex(_ transform: ([UUID]) -> [UUID]) async throws {
        let current = try await loadIndex()
        let updated = transform(current)
        let data = try JSONEncoder().encode(updated.map(\.uuidString))

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: indexKey
        ]

        var status = SecItemCopyMatching(query as CFDictionary, nil)
        if status == errSecItemNotFound {
            let addQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: keychainService,
                kSecAttrAccount as String: indexKey,
                kSecValueData as String: data
            ]
            status = SecItemAdd(addQuery as CFDictionary, nil)
        } else if status == errSecSuccess {
            let attributes: [String: Any] = [kSecValueData as String: data]
            status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        }

        if status != errSecSuccess {
            throw AppError.local(.unknown)
        }
    }
}

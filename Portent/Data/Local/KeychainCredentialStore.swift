//
//  KeychainCredentialStore.swift
//  portent
//
//  CredentialStore implementation backed by ServiceInstanceStorage (Keychain).
//

import Foundation

final class KeychainCredentialStore: CredentialStore {
    private let storage = ServiceInstanceStorage.shared

    func saveInstance(_ instance: ServiceInstance) async throws {
        storage.setBaseUrl(id: instance.id, value: instance.baseUrl)
        storage.setApiKey(id: instance.id, value: instance.apiKey)
        storage.setType(id: instance.id, value: instance.type)
        storage.setName(id: instance.id, value: instance.name)
        storage.setIsDefault(id: instance.id, value: instance.isDefault)
        storage.setIgnoreSslErrors(id: instance.id, value: instance.ignoreSslErrors)
        storage.setIsSearchable(id: instance.id, value: instance.isSearchable)

        var ids = storage.instanceIds
        ids.insert(instance.id.uuidString)
        storage.instanceIds = ids

        let instances = try await getInstances()
        let secrets = Set(instances.flatMap { [$0.apiKey, $0.baseUrl] }.filter { !$0.isEmpty })
        LoggingManager.shared.updateSecrets(secrets)
    }

    func getInstances() async throws -> [ServiceInstance] {
        let ids = storage.instanceIds.compactMap { UUID(uuidString: $0) }
        var instances: [ServiceInstance] = []
        for id in ids {
            if let instance = try await getInstanceById(id) {
                instances.append(instance)
            }
        }
        return instances
    }

    func getInstanceById(_ id: UUID) async throws -> ServiceInstance? {
        let typeRaw = storage.getType(id: id)
        guard !typeRaw.isEmpty else { return nil }

        let type = ServiceType(rawValue: typeRaw) ?? .radarr
        return ServiceInstance(
            id: id,
            type: type,
            name: storage.getName(id: id),
            baseUrl: storage.getBaseUrl(id: id),
            apiKey: storage.getApiKey(id: id),
            isDefault: storage.getIsDefault(id: id),
            ignoreSslErrors: storage.getIgnoreSslErrors(id: id),
            isSearchable: storage.getIsSearchable(id: id)
        )
    }

    func deleteInstance(id: UUID) async throws {
        storage.removeInstance(id: id)
        var ids = storage.instanceIds
        ids.remove(id.uuidString)
        storage.instanceIds = ids

        let instances = try await getInstances()
        let secrets = Set(instances.flatMap { [$0.apiKey, $0.baseUrl] }.filter { !$0.isEmpty })
        LoggingManager.shared.updateSecrets(secrets)
    }

    func updateInstance(_ instance: ServiceInstance) async throws {
        try await saveInstance(instance)
        // saveInstance already calls updateSecrets
    }
}

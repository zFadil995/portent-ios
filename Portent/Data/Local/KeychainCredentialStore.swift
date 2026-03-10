import Foundation

/// Thrown when credential store operations fail (e.g. unsupported service type in v1).
enum CredentialStoreError: Error {
    case unsupportedServiceType
}

/// Keychain-backed CredentialStore. Persists ServiceInstance credentials via ServiceInstanceStorage.
/// v1: Exactly one Radarr and one Sonarr. Each type uses a fixed UUID for stable lookups.
final class KeychainCredentialStore: CredentialStore {

    private static let radarrId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    private static let sonarrId = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!

    private static let supportedTypes: [ServiceType: UUID] = [
        .radarr: radarrId,
        .sonarr: sonarrId
    ]

    func saveInstance(_ instance: ServiceInstance) async throws {
        guard Self.supportedTypes[instance.type] != nil else {
            throw CredentialStoreError.unsupportedServiceType
        }
        let storage = ServiceInstanceStorage.shared(for: instance.type)
        storage.baseUrl = instance.baseUrl
        storage.apiKey = instance.apiKey
        storage.name = instance.name
        storage.ignoreSslErrors = instance.ignoreSslErrors
        storage.isSearchable = instance.isSearchable
        storage.onChanged?()

        let instances = try await getInstances()
        let secrets = Set(instances.flatMap { [$0.apiKey, $0.baseUrl] }.filter { !$0.isEmpty })
        LoggingManager.shared.updateSecrets(secrets)
    }

    func getInstances() async throws -> [ServiceInstance] {
        Self.supportedTypes
            .sorted { $0.value.uuidString < $1.value.uuidString }
            .compactMap { type, id -> ServiceInstance? in
                let storage = ServiceInstanceStorage.shared(for: type)
                guard storage.isConfigured else { return nil }
                return buildInstance(from: storage, id: id, type: type)
            }
    }

    func getInstanceById(_ id: UUID) async throws -> ServiceInstance? {
        guard let type = Self.supportedTypes.first(where: { $0.value == id })?.key else {
            return nil
        }
        let storage = ServiceInstanceStorage.shared(for: type)
        return storage.isConfigured ? buildInstance(from: storage, id: id, type: type) : nil
    }

    func deleteInstance(id: UUID) async throws {
        if let type = Self.supportedTypes.first(where: { $0.value == id })?.key {
            ServiceInstanceStorage.shared(for: type).clear()
        }
        let instances = try await getInstances()
        let secrets = Set(instances.flatMap { [$0.apiKey, $0.baseUrl] }.filter { !$0.isEmpty })
        LoggingManager.shared.updateSecrets(secrets)
    }

    func updateInstance(_ instance: ServiceInstance) async throws {
        try await saveInstance(instance)
    }

    private func buildInstance(from storage: ServiceInstanceStorage, id: UUID, type: ServiceType) -> ServiceInstance {
        ServiceInstance(
            id: id,
            type: type,
            name: storage.name.isEmpty ? type.defaultDisplayName : storage.name,
            baseUrl: storage.baseUrl,
            apiKey: storage.apiKey,
            isDefault: type == .radarr,
            ignoreSslErrors: storage.ignoreSslErrors,
            isSearchable: storage.isSearchable
        )
    }
}

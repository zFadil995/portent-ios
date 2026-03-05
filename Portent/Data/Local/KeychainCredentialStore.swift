import Foundation

/// Thrown when credential store operations fail (e.g. unsupported service type in v1).
enum CredentialStoreError: Error {
    case unsupportedServiceType
}

/// Keychain-backed CredentialStore. Persists ServiceInstance credentials via RadarrSecureStorage and SonarrSecureStorage.
/// v1: Exactly one Radarr and one Sonarr.
final class KeychainCredentialStore: CredentialStore {
    private let radarrStorage = RadarrSecureStorage.shared
    private let sonarrStorage = SonarrSecureStorage.shared

    private static let radarrId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    private static let sonarrId = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!

    func saveInstance(_ instance: ServiceInstance) async throws {
        switch instance.type {
        case .radarr:
            radarrStorage.baseUrl = instance.baseUrl
            radarrStorage.apiKey = instance.apiKey
            radarrStorage.name = instance.name
            radarrStorage.ignoreSslErrors = instance.ignoreSslErrors
            radarrStorage.isSearchable = instance.isSearchable
            radarrStorage.onRadarrChanged?()
        case .sonarr:
            sonarrStorage.baseUrl = instance.baseUrl
            sonarrStorage.apiKey = instance.apiKey
            sonarrStorage.name = instance.name
            sonarrStorage.ignoreSslErrors = instance.ignoreSslErrors
            sonarrStorage.isSearchable = instance.isSearchable
            sonarrStorage.onSonarrChanged?()
        default:
            throw CredentialStoreError.unsupportedServiceType
        }

        let instances = try await getInstances()
        let secrets = Set(instances.flatMap { [$0.apiKey, $0.baseUrl] }.filter { !$0.isEmpty })
        LoggingManager.shared.updateSecrets(secrets)
    }

    func getInstances() async throws -> [ServiceInstance] {
        var instances: [ServiceInstance] = []
        if radarrStorage.isConfigured {
            instances.append(buildRadarrInstance())
        }
        if sonarrStorage.isConfigured {
            instances.append(buildSonarrInstance())
        }
        return instances
    }

    func getInstanceById(_ id: UUID) async throws -> ServiceInstance? {
        switch id {
        case Self.radarrId:
            return radarrStorage.isConfigured ? buildRadarrInstance() : nil
        case Self.sonarrId:
            return sonarrStorage.isConfigured ? buildSonarrInstance() : nil
        default:
            return nil
        }
    }

    func deleteInstance(id: UUID) async throws {
        switch id {
        case Self.radarrId:
            radarrStorage.clear()
        case Self.sonarrId:
            sonarrStorage.clear()
        default:
            break
        }

        let instances = try await getInstances()
        let secrets = Set(instances.flatMap { [$0.apiKey, $0.baseUrl] }.filter { !$0.isEmpty })
        LoggingManager.shared.updateSecrets(secrets)
    }

    func updateInstance(_ instance: ServiceInstance) async throws {
        try await saveInstance(instance)
    }

    private func buildRadarrInstance() -> ServiceInstance {
        ServiceInstance(
            id: Self.radarrId,
            type: .radarr,
            name: radarrStorage.name,
            baseUrl: radarrStorage.baseUrl,
            apiKey: radarrStorage.apiKey,
            isDefault: true,
            ignoreSslErrors: radarrStorage.ignoreSslErrors,
            isSearchable: radarrStorage.isSearchable
        )
    }

    private func buildSonarrInstance() -> ServiceInstance {
        ServiceInstance(
            id: Self.sonarrId,
            type: .sonarr,
            name: sonarrStorage.name,
            baseUrl: sonarrStorage.baseUrl,
            apiKey: sonarrStorage.apiKey,
            isDefault: false,
            ignoreSslErrors: sonarrStorage.ignoreSslErrors,
            isSearchable: sonarrStorage.isSearchable
        )
    }
}

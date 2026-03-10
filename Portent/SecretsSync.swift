import Foundation

/// Syncs PII secrets from all configured ServiceInstanceStorage instances to LoggingManager for sanitization.
/// Call on app startup (after loading instances) and whenever any instance config is added, edited, or deleted.
/// Secrets = apiKey and baseUrl per instance (per docs/analytics.md).
func syncSecretsToLoggingManager() {
    let manager = LoggingManager.shared
    let supportedTypes: [ServiceType] = [.radarr, .sonarr]
    var secrets: Set<String> = []
    for type in supportedTypes {
        let storage = ServiceInstanceStorage.shared(for: type)
        if storage.isConfigured {
            if !storage.baseUrl.isEmpty { secrets.insert(storage.baseUrl) }
            if !storage.apiKey.isEmpty { secrets.insert(storage.apiKey) }
        }
    }
    manager.updateSecrets(secrets)
}

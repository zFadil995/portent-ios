import Foundation

/// Syncs PII secrets from RadarrSecureStorage and SonarrSecureStorage to LoggingManager for sanitization.
/// Call on app startup (after loading instances) and whenever Radarr/Sonarr config is added, edited, or deleted.
/// Secrets = apiKey and baseUrl per instance (per docs/analytics.md).
func syncSecretsToLoggingManager() {
    let manager = LoggingManager.shared
    var secrets: Set<String> = []
    if RadarrSecureStorage.shared.isConfigured {
        if !RadarrSecureStorage.shared.baseUrl.isEmpty { secrets.insert(RadarrSecureStorage.shared.baseUrl) }
        if !RadarrSecureStorage.shared.apiKey.isEmpty { secrets.insert(RadarrSecureStorage.shared.apiKey) }
    }
    if SonarrSecureStorage.shared.isConfigured {
        if !SonarrSecureStorage.shared.baseUrl.isEmpty { secrets.insert(SonarrSecureStorage.shared.baseUrl) }
        if !SonarrSecureStorage.shared.apiKey.isEmpty { secrets.insert(SonarrSecureStorage.shared.apiKey) }
    }
    manager.updateSecrets(secrets)
}

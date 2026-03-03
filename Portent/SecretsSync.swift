import Foundation

/// Syncs PII secrets from ServiceInstanceStorage to LoggingManager for sanitization.
/// Call on app startup (after loading instances) and whenever instances are added, edited, or deleted.
/// Secrets = apiKey and baseUrl per instance (per docs/analytics.md).
///
/// TODO: Wire on addInstance/updateInstance when CRUD flows exist.
/// Call syncSecretsToLoggingManager (or trigger onInstancesChanged) after save.
/// Otherwise new apiKey/baseUrl not in knownSecrets until app restart.
func syncSecretsToLoggingManager() {
    let storage = ServiceInstanceStorage.shared
    let manager = LoggingManager.shared
    var secrets: Set<String> = []
    for idStr in storage.instanceIds {
        guard let id = UUID(uuidString: idStr) else { continue }
        let baseUrl = storage.getBaseUrl(id: id)
        let apiKey = storage.getApiKey(id: id)
        if !baseUrl.isEmpty { secrets.insert(baseUrl) }
        if !apiKey.isEmpty { secrets.insert(apiKey) }
    }
    manager.updateSecrets(secrets)
}

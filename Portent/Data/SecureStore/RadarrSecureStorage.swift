import Foundation

/// Domain-scoped storage for Radarr credentials.
/// v1: Exactly one Radarr instance. Keys: baseUrl, apiKey, name, ignoreSslErrors, isSearchable.
final class RadarrSecureStorage: SecureStorage {
    static let shared = RadarrSecureStorage()

    /// Invoked when Radarr config is added, edited, or deleted. Used to sync secrets to LoggingManager.
    var onRadarrChanged: (() -> Void)?

    private convenience init() {
        self.init(store: SecureStore.shared)
    }

    init(store: SecureStoreProtocol) {
        super.init(domain: "radarr", store: store)
    }

    var baseUrl: String {
        get { read(key: "baseUrl", default: "") }
        set { write(key: "baseUrl", value: newValue) }
    }

    var apiKey: String {
        get { read(key: "apiKey", default: "") }
        set { write(key: "apiKey", value: newValue) }
    }

    var name: String {
        get { read(key: "name", default: "Radarr") }
        set { write(key: "name", value: newValue) }
    }

    var ignoreSslErrors: Bool {
        get { readBool(key: "ignoreSslErrors", default: false) }
        set { writeBool(key: "ignoreSslErrors", value: newValue) }
    }

    var isSearchable: Bool {
        get { readBool(key: "isSearchable", default: true) }
        set { writeBool(key: "isSearchable", value: newValue) }
    }

    var isConfigured: Bool {
        !baseUrl.isEmpty && !apiKey.isEmpty
    }

    func clear() {
        baseUrl = ""
        apiKey = ""
        name = "Radarr"
        ignoreSslErrors = false
        isSearchable = true
        onRadarrChanged?()
    }
}

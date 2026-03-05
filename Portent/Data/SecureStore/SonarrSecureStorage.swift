import Foundation

/// Domain-scoped storage for Sonarr credentials.
/// v1: Exactly one Sonarr instance. Keys: baseUrl, apiKey, name, ignoreSslErrors, isSearchable.
final class SonarrSecureStorage: SecureStorage {
    static let shared = SonarrSecureStorage()

    /// Invoked when Sonarr config is added, edited, or deleted. Used to sync secrets to LoggingManager.
    var onSonarrChanged: (() -> Void)?

    private convenience init() {
        self.init(store: SecureStore.shared)
    }

    init(store: SecureStoreProtocol) {
        super.init(domain: "sonarr", store: store)
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
        get { read(key: "name", default: "Sonarr") }
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
        name = "Sonarr"
        ignoreSslErrors = false
        isSearchable = true
        onSonarrChanged?()
    }
}

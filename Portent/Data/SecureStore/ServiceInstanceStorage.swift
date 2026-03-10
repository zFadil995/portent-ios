import Foundation

/// Credential storage for a single service instance, keyed by ServiceType.
/// Domain follows the cross-platform key format: lowercased type raw value (e.g. "radarr").
///
/// v1: One instance per supported ServiceType. Use `ServiceInstanceStorage.shared(for:)`
/// to access the per-type singleton. Pass a custom `SecureStoreProtocol` in tests.
@MainActor
final class ServiceInstanceStorage: SecureStorage {

    let type: ServiceType

    /// Invoked when any credential for this instance is added, edited, or deleted.
    /// Used to sync secrets to LoggingManager for PII sanitization.
    var onChanged: (() -> Void)?

    // MARK: - Shared singletons (production, keyed by ServiceType)

    private static var registry: [ServiceType: ServiceInstanceStorage] = [:]

    static func shared(for type: ServiceType) -> ServiceInstanceStorage {
        if let existing = registry[type] { return existing }
        let storage = ServiceInstanceStorage(type: type)
        registry[type] = storage
        return storage
    }

    // MARK: - Init

    convenience init(type: ServiceType) {
        self.init(type: type, store: SecureStore.shared)
    }

    init(type: ServiceType, store: SecureStoreProtocol) {
        self.type = type
        super.init(domain: type.rawValue.lowercased(), store: store)
    }

    // MARK: - Fields

    var baseUrl: String {
        get { read(key: "baseUrl", default: "") }
        set { write(key: "baseUrl", value: newValue) }
    }

    var apiKey: String {
        get { read(key: "apiKey", default: "") }
        set { write(key: "apiKey", value: newValue) }
    }

    /// User-defined label for the instance. Empty means the user has not set a name;
    /// callers should fall back to `type.defaultDisplayName` for display.
    var name: String {
        get { read(key: "name", default: "") }
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

    // MARK: - Reset

    func clear() {
        baseUrl = ""
        apiKey = ""
        name = ""
        ignoreSslErrors = false
        isSearchable = true
        onChanged?()
    }

    deinit { }
}

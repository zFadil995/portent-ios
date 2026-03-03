import Foundation

/// Domain-scoped storage for service instance credentials. Key structure mirrors Android
/// ServiceInstanceStorage (per-instance: baseUrl, apiKey, type, name, isDefault, ignoreSslErrors, isSearchable).
final class ServiceInstanceStorage: SecureStorage {
    static let shared = ServiceInstanceStorage()

    private convenience init() {
        self.init(store: SecureStore.shared)
    }

    init(store: SecureStoreProtocol) {
        super.init(domain: "service_instance", store: store)
    }

    var instanceIds: Set<String> {
        get {
            let raw = read(key: "instance_ids", default: "[]")
            guard let data = raw.data(using: .utf8),
                  let arr = try? JSONDecoder().decode([String].self, from: data)
            else { return [] }
            return Set(arr)
        }
        set {
            let arr = Array(newValue)
            guard let data = try? JSONEncoder().encode(arr),
                  let raw = String(data: data, encoding: .utf8)
            else { return }
            write(key: "instance_ids", value: raw)
        }
    }

    func getBaseUrl(id: UUID) -> String {
        read(key: "instance_\(id.uuidString.lowercased())_baseUrl", default: "")
    }

    func setBaseUrl(id: UUID, value: String) {
        write(key: "instance_\(id.uuidString.lowercased())_baseUrl", value: value)
    }

    func getApiKey(id: UUID) -> String {
        read(key: "instance_\(id.uuidString.lowercased())_apiKey", default: "")
    }

    func setApiKey(id: UUID, value: String) {
        write(key: "instance_\(id.uuidString.lowercased())_apiKey", value: value)
    }

    func getType(id: UUID) -> String {
        read(key: "instance_\(id.uuidString.lowercased())_type", default: "")
    }

    func setType(id: UUID, value: ServiceType) {
        write(key: "instance_\(id.uuidString.lowercased())_type", value: value.rawValue)
    }

    func getName(id: UUID) -> String {
        read(key: "instance_\(id.uuidString.lowercased())_name", default: "")
    }

    func setName(id: UUID, value: String) {
        write(key: "instance_\(id.uuidString.lowercased())_name", value: value)
    }

    func getIsDefault(id: UUID) -> Bool {
        readBool(key: "instance_\(id.uuidString.lowercased())_isDefault", default: false)
    }

    func setIsDefault(id: UUID, value: Bool) {
        writeBool(key: "instance_\(id.uuidString.lowercased())_isDefault", value: value)
    }

    func getIgnoreSslErrors(id: UUID) -> Bool {
        readBool(key: "instance_\(id.uuidString.lowercased())_ignoreSslErrors", default: false)
    }

    func setIgnoreSslErrors(id: UUID, value: Bool) {
        writeBool(key: "instance_\(id.uuidString.lowercased())_ignoreSslErrors", value: value)
    }

    func getIsSearchable(id: UUID) -> Bool {
        readBool(key: "instance_\(id.uuidString.lowercased())_isSearchable", default: true)
    }

    func setIsSearchable(id: UUID, value: Bool) {
        writeBool(key: "instance_\(id.uuidString.lowercased())_isSearchable", value: value)
    }

    func removeInstance(id: UUID) {
        let keys = [
            "instance_\(id.uuidString.lowercased())_baseUrl",
            "instance_\(id.uuidString.lowercased())_apiKey",
            "instance_\(id.uuidString.lowercased())_type",
            "instance_\(id.uuidString.lowercased())_name",
            "instance_\(id.uuidString.lowercased())_isDefault",
            "instance_\(id.uuidString.lowercased())_ignoreSslErrors",
            "instance_\(id.uuidString.lowercased())_isSearchable"
        ]
        for key in keys {
            remove(key: key)
        }
        // Must update instanceIds to prevent orphaned IDs after deletion
        var ids = instanceIds
        ids.remove(id.uuidString.lowercased())
        instanceIds = ids
    }
}

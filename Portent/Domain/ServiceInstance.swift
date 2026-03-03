import Foundation

/// Domain model for a configured service instance.
/// apiKey and baseUrl must be redacted by PiiSanitizer before logging.
/// Codable for JSON serialization; all 8 fields map 1:1 to camelCase keys.
struct ServiceInstance: Identifiable, Codable {
    let id: UUID
    let type: ServiceType
    let name: String
    let baseUrl: String
    let apiKey: String
    let isDefault: Bool
    let ignoreSslErrors: Bool
    let isSearchable: Bool
}

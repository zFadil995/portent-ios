import Foundation

/// Domain model for a configured service instance.
/// apiKey and baseUrl must be redacted by PiiSanitizer before logging.
struct ServiceInstance: Identifiable {
    let id: UUID
    let type: ServiceType
    let name: String
    let baseUrl: String
    let apiKey: String
    let isDefault: Bool
    let ignoreSslErrors: Bool
    let isSearchable: Bool
}

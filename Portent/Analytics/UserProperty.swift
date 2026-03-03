import Foundation

/// Analytics user properties. Key/value format must match Android for cross-platform reporting.
enum UserProperty {
    case serviceInstanceCount(count: Int)
    case activeServiceTypes(types: [ServiceType])
    case themePreference(theme: String)
    case analyticsOptInDate(date: String)

    var key: String {
        switch self {
        case .serviceInstanceCount: return "service_instance_count"
        case .activeServiceTypes: return "active_service_types"
        case .themePreference: return "theme_preference"
        case .analyticsOptInDate: return "analytics_opt_in_date"
        }
    }

    var value: String {
        switch self {
        case .serviceInstanceCount(let count): return count.description
        case .activeServiceTypes(let types): return types.map { $0.rawValue.lowercased() }.joined(separator: ",")
        case .themePreference(let theme): return theme
        case .analyticsOptInDate(let date): return date
        }
    }
}

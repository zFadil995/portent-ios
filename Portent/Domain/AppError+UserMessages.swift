import Foundation

/// Maps AppError to user-facing strings. Non-sensitive; no URLs, keys, or tokens.
extension AppError {
    func toUserMessage() -> String {
        switch self {
        case .network(.unreachable):
            return String(localized: "error_network_unreachable")
        case .network(.timeout):
            return String(localized: "error_network_timeout")
        case .network(.sslError):
            return String(localized: "error_network_ssl")
        case .network(.invalidResponse):
            return String(localized: "error_network_invalid_response")
        case .api(.unauthorized):
            return String(localized: "error_api_unauthorized")
        case .api(.forbidden):
            return String(localized: "error_api_forbidden")
        case .api(.notFound):
            return String(localized: "error_api_not_found")
        case .api(.serverError):
            return String(localized: "error_api_server_error")
        case .api(.unexpectedResponse):
            return String(localized: "error_api_unexpected")
        case .config(.noInstanceConfigured):
            return String(localized: "error_config_no_instance")
        case .config(.invalidBaseUrl):
            return String(localized: "error_config_invalid_base_url")
        case .config(.missingApiKey):
            return String(localized: "error_config_missing_api_key")
        case .local(.unknown):
            return String(localized: "error_local_unknown")
        }
    }
}

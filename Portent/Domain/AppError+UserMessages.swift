import Foundation

/// Maps AppError to user-facing strings. Non-sensitive; no URLs, keys, or tokens.
extension AppError {
    func toUserMessage() -> String {
        switch self {
        case .network(.unreachable):
            return "Unable to connect. Check your network."
        case .network(.timeout):
            return "Request timed out. Try again."
        case .network(.sslError):
            return "Connection not secure. Check server certificate."
        case .network(.invalidResponse):
            return "Invalid response from server."
        case .api(.unauthorized):
            return "Access denied. Check your API key."
        case .api(.forbidden):
            return "You don't have permission for this."
        case .api(.notFound):
            return "Not found."
        case .api(.serverError):
            return "Server error. Try again later."
        case .api(.unexpectedResponse):
            return "Unexpected response from server."
        case .config(.noInstanceConfigured):
            return "No instance configured."
        case .config(.invalidBaseUrl):
            return "Invalid server address."
        case .config(.missingApiKey):
            return "API key is required."
        case .local(.unknown):
            return "Something went wrong. Try again."
        }
    }
}

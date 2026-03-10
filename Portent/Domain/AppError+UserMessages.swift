import Foundation

/// Maps AppError to user-facing strings. Non-sensitive; no URLs, keys, or tokens.
extension AppError {
    func toUserMessage() -> String {
        switch self {
        case .network(let err): return networkMessage(err)
        case .api(let err): return apiMessage(err)
        case .config(let err): return configMessage(err)
        case .local(let err): return localMessage(err)
        }
    }

    private func networkMessage(_ error: NetworkError) -> String {
        switch error {
        case .unreachable:
            return String(localized: "error_network_unreachable")
        case .timeout:
            return String(localized: "error_network_timeout")
        case .sslError:
            return String(localized: "error_network_ssl")
        case .invalidResponse:
            return String(localized: "error_network_invalid_response")
        }
    }

    private func apiMessage(_ error: ApiError) -> String {
        switch error {
        case .unauthorized:
            return String(localized: "error_api_unauthorized")
        case .forbidden:
            return String(localized: "error_api_forbidden")
        case .notFound:
            return String(localized: "error_api_not_found")
        case .serverError:
            return String(localized: "error_api_server_error")
        case .unexpectedResponse:
            return String(localized: "error_api_unexpected")
        }
    }

    private func configMessage(_ error: ConfigError) -> String {
        switch error {
        case .noInstanceConfigured:
            return String(localized: "error_config_no_instance")
        case .invalidBaseUrl:
            return String(localized: "error_config_invalid_base_url")
        case .missingApiKey:
            return String(localized: "error_config_missing_api_key")
        }
    }

    private func localMessage(_ error: LocalError) -> String {
        switch error {
        case .unknown:
            return String(localized: "error_local_unknown")
        }
    }
}

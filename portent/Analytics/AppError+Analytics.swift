//
//  AppError+Analytics.swift
//  portent
//

import Foundation

extension AppError {
    var analyticsCode: String {
        switch self {
        case .network(let err):
            switch err {
            case .unreachable: return "network_unreachable"
            case .timeout: return "network_timeout"
            case .sslError: return "network_ssl_error"
            case .invalidResponse(let code): return "network_invalid_response_\(code)"
            }
        case .api(let err):
            switch err {
            case .unauthorized: return "api_unauthorized"
            case .forbidden: return "api_forbidden"
            case .notFound: return "api_not_found"
            case .serverError(let code): return "api_server_error_\(code)"
            case .unexpectedResponse: return "api_unexpected_response"
            }
        case .config(let err):
            switch err {
            case .noInstanceConfigured: return "config_no_instance"
            case .invalidBaseUrl: return "config_invalid_url"
            case .missingApiKey: return "config_missing_key"
            }
        case .local(let err):
            switch err {
            case .unknown: return "local_unknown"
            }
        }
    }
}

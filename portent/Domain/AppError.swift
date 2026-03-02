//
//  AppError.swift
//  portent
//

import Foundation

/// Domain error hierarchy.
/// Map raw exceptions and HTTP status codes at the data boundary.
enum AppError: Error {
    case network(NetworkError)
    case api(ApiError)
    case config(ConfigError)
    case local(LocalError)

    enum NetworkError {
        case unreachable
        case timeout
        case sslError
        case invalidResponse(statusCode: Int)
    }

    enum ApiError {
        case unauthorized
        case forbidden
        case notFound
        case serverError(code: Int)
        case unexpectedResponse
    }

    enum ConfigError {
        case noInstanceConfigured(type: ServiceType)
        case invalidBaseUrl
        case missingApiKey
    }

    enum LocalError {
        case unknown
    }
}

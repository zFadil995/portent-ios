//
//  NetworkError+Mapping.swift
//  portent
//

import Foundation

/// Maps URLSession errors and HTTP responses to AppError.
enum NetworkErrorMapper {
    /// Maps URLError to AppError.Network.
    static func map(_ error: URLError) -> AppError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .network(.unreachable)
        case .timedOut:
            return .network(.timeout)
        case .serverCertificateUntrusted, .serverCertificateHasBadDate,
             .serverCertificateHasUnknownRoot, .serverCertificateNotYetValid,
             .clientCertificateRejected, .clientCertificateRequired:
            return .network(.sslError)
        default:
            return .network(.invalidResponse(statusCode: error.code.rawValue))
        }
    }

    /// Maps HTTP status code to AppError.ApiError.
    static func map(statusCode: Int) -> AppError {
        switch statusCode {
        case 401:
            return .api(.unauthorized)
        case 403:
            return .api(.forbidden)
        case 404:
            return .api(.notFound)
        case 500...599:
            return .api(.serverError(code: statusCode))
        default:
            return .api(.unexpectedResponse)
        }
    }

    /// Maps DecodingError to AppError.
    static func map(_ error: DecodingError) -> AppError {
        .network(.invalidResponse(statusCode: 0))
    }
}

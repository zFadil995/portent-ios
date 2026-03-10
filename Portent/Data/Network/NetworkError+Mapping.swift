import Foundation

// TODO: Wire NetworkErrorMapper in APIClient.request() when API layer is implemented.
// Checklist: (1) catch URLError → map(_:); (2) validate HTTPURLResponse.statusCode → map(statusCode:);
// (3) catch DecodingError → map(_:). Raw errors must not leak to UI. See docs/api-integrations.md.

/// Maps URLSession errors and HTTP responses to AppError.
enum NetworkErrorMapper {
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

    static func map(statusCode: Int) -> AppError {
        switch statusCode {
        case HTTPStatusCode.unauthorized:
            return .api(.unauthorized)
        case HTTPStatusCode.forbidden:
            return .api(.forbidden)
        case HTTPStatusCode.notFound:
            return .api(.notFound)
        case HTTPStatusCode.serverErrorRange:
            return .api(.serverError(code: statusCode))
        default:
            return .api(.unexpectedResponse)
        }
    }

    static func map(_ error: DecodingError) -> AppError {
        .api(.unexpectedResponse)
    }
}

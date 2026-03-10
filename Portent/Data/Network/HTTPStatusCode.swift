import Foundation

/// Named HTTP status code constants used in NetworkErrorMapper and future APIClient.
enum HTTPStatusCode {
    static let successRange = 200..<300
    static let unauthorized = 401
    static let forbidden = 403
    static let notFound = 404
    static let serverErrorRange = 500...599
}

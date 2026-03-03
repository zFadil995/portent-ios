import Foundation

// TODO: When implementing `request`, wire NetworkErrorMapper for URLError, HTTP status codes, and DecodingError.
// Raw errors must not leak to domain/UI. See docs/api-integrations.md (Error Mapping).

/// Generic API client protocol.
/// Each service conforms to this for its specific endpoint set.
///
/// When implementing `request`, use `NetworkErrorMapper` to map URLError, HTTP status codes,
/// and DecodingError to AppError so raw errors do not leak to the domain layer.
protocol APIClient {
    var baseURL: URL { get }
    var session: URLSession { get }
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

/// Encapsulates path, method, query params, and body for a single API request.
struct Endpoint {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]?
    let body: Data?

    init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
    }
}

/// HTTP method for API requests.
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

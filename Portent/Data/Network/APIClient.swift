//
//  APIClient.swift
//  portent
//

import Foundation

/// Generic API client protocol.
/// Each service conforms to this for its specific endpoint set.
protocol APIClient {
    var baseURL: URL { get }
    var session: URLSession { get }
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

/// Represents a single API endpoint.
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

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

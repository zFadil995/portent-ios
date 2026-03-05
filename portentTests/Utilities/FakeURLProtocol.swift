import Foundation
@testable import Portent

/// URLProtocol stub that intercepts URLSession requests and returns controllable responses.
/// Use for ViewModel tests that need API calls without real network.
///
/// Usage:
/// ```swift
/// FakeURLProtocol.responseProvider = { _ in (200, validJsonData) }
/// let config = URLSessionConfiguration.ephemeral
/// config.protocolClasses = [FakeURLProtocol.self]
/// let session = URLSession(configuration: config)
/// // Inject session into APIClient; run ViewModel test
/// ```
///
/// See docs/testing-strategy.md for full testing patterns.
final class FakeURLProtocol: URLProtocol {

    /// Set before each test. Receives the request; returns (statusCode, body) or nil to fail.
    /// nonisolated(unsafe): test-only; tests set this synchronously before running.
    nonisolated(unsafe) static var responseProvider: ((URLRequest) -> (Int, Data)?)?

    override static func canInit(with request: URLRequest) -> Bool {
        true
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let client = client else { return }
        let provider = Self.responseProvider
        if let (statusCode, data) = provider?(request) {
            guard let url = request.url ?? URL(string: "https://fake.test/"),
                  let response = HTTPURLResponse(
                      url: url,
                      statusCode: statusCode,
                      httpVersion: "1.1",
                      headerFields: ["Content-Type": "application/json"]
                  )
            else {
                client.urlProtocol(self, didFailWithError: URLError(.unknown))
                client.urlProtocolDidFinishLoading(self)
                return
            }
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client.urlProtocol(self, didLoad: data)
        } else {
            client.urlProtocol(self, didFailWithError: URLError(.unknown))
        }
        client.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

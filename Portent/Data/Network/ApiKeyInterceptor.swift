import Foundation

/// Helper that decorates a URLRequest with API key and JSON headers.
/// URLSession has no interceptor chain; call this before performing requests.
struct ApiKeyInterceptor {
    let apiKey: String

    func intercept(_ request: URLRequest) -> URLRequest {
        var modified = request
        modified.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        modified.setValue("application/json", forHTTPHeaderField: "Accept")
        modified.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return modified
    }
}

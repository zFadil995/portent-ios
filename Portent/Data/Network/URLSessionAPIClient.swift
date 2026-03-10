import Foundation

/// Concrete APIClient implementation backed by URLSession.
///
/// Builds each request from an `Endpoint`, applies the API key header via `ApiKeyInterceptor`,
/// performs the request on the injected session, and maps all errors to `AppError` via
/// `NetworkErrorMapper`. Raw URLError, HTTP status errors, and DecodingErrors never
/// escape this layer — they are all mapped at the data boundary.
///
/// Usage (production):
/// ```swift
/// let client = URLSessionAPIClient(instance: instance)
/// let movies: [MovieDto] = try await client.request(RadarrEndpoint.movies)
/// ```
///
/// Usage (testing): inject `FakeAPIClient` instead — both conform to `APIClient`.
final class URLSessionAPIClient: APIClient {

    let baseURL: URL
    let session: URLSession
    private let interceptor: ApiKeyInterceptor

    // MARK: - Init

    /// Creates a client for the given service instance.
    /// Throws `AppError.config(.invalidBaseUrl)` if `instance.baseUrl` cannot be parsed.
    init(instance: ServiceInstance) throws {
        guard let url = URL(string: instance.baseUrl), url.scheme != nil, url.host != nil else {
            throw AppError.config(.invalidBaseUrl)
        }
        self.baseURL = url
        self.session = PortentURLSession.session(for: instance)
        self.interceptor = ApiKeyInterceptor(apiKey: instance.apiKey)
    }

    /// Memberwise init for testing and internal factory use.
    init(baseURL: URL, session: URLSession, apiKey: String) {
        self.baseURL = baseURL
        self.session = session
        self.interceptor = ApiKeyInterceptor(apiKey: apiKey)
    }

    // MARK: - APIClient

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let urlRequest = try buildRequest(for: endpoint)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let urlError as URLError {
            throw NetworkErrorMapper.map(urlError)
        } catch {
            throw AppError.network(.invalidResponse(statusCode: 0))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.network(.invalidResponse(statusCode: 0))
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkErrorMapper.map(statusCode: httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            throw NetworkErrorMapper.map(decodingError)
        } catch {
            throw AppError.api(.unexpectedResponse)
        }
    }

    // MARK: - Private

    private func buildRequest(for endpoint: Endpoint) throws -> URLRequest {
        let fullURL = baseURL.appendingPathComponent(endpoint.path)

        var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: true)
        components?.queryItems = endpoint.queryItems

        guard let url = components?.url else {
            throw AppError.config(.invalidBaseUrl)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        return interceptor.intercept(request)
    }
}

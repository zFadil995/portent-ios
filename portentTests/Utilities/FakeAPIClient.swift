import Foundation
@testable import Portent

/// Test double conforming to `APIClient`. Returns controllable success or error
/// responses so ViewModels and repositories can be tested without real network.
///
/// Usage:
/// ```swift
/// let fake = FakeAPIClient()
/// try fake.enqueueSuccess(MovieDto(id: 1, title: "Dune"))
/// let viewModel = SomeViewModel(apiClient: fake)
/// await viewModel.load()
/// // assert state
///
/// fake.enqueueError(.network(.unreachable))
/// await viewModel.load()
/// // assert error state
/// ```
///
/// Reset with `clear()` in `tearDown` to prevent cross-test leakage.
/// See docs/testing-strategy.md for full testing patterns.
final class FakeAPIClient: APIClient {

    let baseURL: URL
    let session: URLSession

    private var responseQueue: [Result<Data, AppError>] = []

    init(baseURL: URL = URL(string: "https://fake.test/")!) {
        self.baseURL = baseURL
        self.session = .shared
    }

    // MARK: - Enqueue helpers

    /// Enqueue a successful response. The value is JSON-encoded and decoded
    /// back by `request<T>`, so the type must be both Encodable and Decodable.
    func enqueueSuccess<T: Encodable>(_ value: T) throws {
        let data = try JSONEncoder().encode(value)
        responseQueue.append(.success(data))
    }

    /// Enqueue a raw JSON string as a successful response.
    func enqueueSuccessJSON(_ json: String) {
        let data = Data(json.utf8)
        responseQueue.append(.success(data))
    }

    /// Enqueue an error. The next `request` call will throw it.
    func enqueueError(_ error: AppError) {
        responseQueue.append(.failure(error))
    }

    /// Remove all enqueued responses.
    func clear() {
        responseQueue.removeAll()
    }

    // MARK: - APIClient

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard !responseQueue.isEmpty else {
            throw AppError.local(.unknown)
        }
        switch responseQueue.removeFirst() {
        case .success(let data):
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw AppError.api(.unexpectedResponse)
            }
        case .failure(let error):
            throw error
        }
    }
}

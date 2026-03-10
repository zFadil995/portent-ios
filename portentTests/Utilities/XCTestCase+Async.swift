import XCTest

extension XCTestCase {
    /// Runs an async test body with a default timeout of 5 seconds.
    func asyncTest(
        timeout: TimeInterval = 5,
        _ body: @escaping @MainActor @Sendable () async throws -> Void
    ) {
        let expectation = expectation(description: "async test")
        Task { @MainActor in
            do {
                try await body()
            } catch {
                XCTFail("Async test threw: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
}

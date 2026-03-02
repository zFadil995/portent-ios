//
//  XCTestCase+Async.swift
//  portentTests
//

import XCTest

extension XCTestCase {
    /// Runs an async test body with a default timeout of 5 seconds.
    func asyncTest(
        timeout: TimeInterval = 5,
        _ body: @escaping () async throws -> Void
    ) {
        let expectation = expectation(description: "async test")
        Task {
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

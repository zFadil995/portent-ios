// Integration tests for updateSecrets → LoggingManager → sanitize chain.
// Test 3 will FAIL if AnalyticsEvent.sanitized(secrets:) still returns self
// without parameter sanitization (see C-02).

import XCTest
@testable import Portent

@MainActor
final class PiiSanitizerIntegrationTests: XCTestCase {

    /// Spy that captures events passed to logEvent for assertion.
    private final class SpyLoggingService: LoggingService {
        var capturedEvent: AnalyticsEvent?
        var capturedEvents: [AnalyticsEvent] = []

        func logEvent(_ event: AnalyticsEvent) {
            capturedEvent = event
            capturedEvents.append(event)
        }

        func logScreen(_ screen: Screen) {}
        func logError(_ error: AppError, context: ErrorContext) {}
        func logNonFatal(_ error: AppError, context: ErrorContext) {}
        func setUserProperty(_ property: UserProperty) {}
        func startSession() {}
        func endSession() {}
    }

    private var spy: SpyLoggingService?

    override func setUp() async throws {
        try await super.setUp()
        spy = SpyLoggingService()
    }

    override func tearDown() async throws {
        // Reset LoggingManager.shared so tests are order-independent; singleton state
        // must not leak between tests (knownSecrets, services).
        LoggingManager.shared.configure(services: [])
        LoggingManager.shared.updateSecrets(Set<String>())
        spy = nil
        try await super.tearDown()
    }

    // MARK: - Test 1: updateSecrets then logEvent redacts API key

    func test_updateSecrets_thenLogEvent_redactsApiKey() throws {
        let spy = try XCTUnwrap(spy)
        let secret = "my-secret-key"
        LoggingManager.shared.updateSecrets([secret])
        LoggingManager.shared.configure(services: [spy])

        let event = AnalyticsEvent.errorOccurred(errorCode: secret, screen: .dashboard)
        LoggingManager.shared.logEvent(event)

        let loggedEvent = spy.capturedEvent
        XCTAssertNotNil(loggedEvent, "Spy should have received the event")

        let paramsStr = loggedEvent?.parameters.values.joined(separator: " ") ?? ""
        XCTAssertFalse(
            paramsStr.contains(secret),
            "Logged event params must NOT contain '\(secret)'. Got: \(paramsStr). " +
            "If this fails, AnalyticsEvent.sanitized(secrets:) may still return self without sanitization (C-02)."
        )
    }

    // MARK: - Test 2: updateSecrets then logEvent redacts base URL

    func test_updateSecrets_thenLogEvent_redactsBaseUrl() throws {
        let spy = try XCTUnwrap(spy)
        let baseUrl = "https://my-server.local"
        LoggingManager.shared.updateSecrets([baseUrl])
        LoggingManager.shared.configure(services: [spy])

        let event = AnalyticsEvent.errorOccurred(errorCode: baseUrl, screen: .dashboard)
        LoggingManager.shared.logEvent(event)

        let loggedEvent = spy.capturedEvent
        XCTAssertNotNil(loggedEvent)

        let paramsStr = loggedEvent?.parameters.values.joined(separator: " ") ?? ""
        XCTAssertFalse(
            paramsStr.contains(baseUrl),
            "Logged event params must NOT contain '\(baseUrl)'. Got: \(paramsStr)."
        )
    }

    // MARK: - Test 3: sanitized(secrets:) redacts parameters

    func test_sanitizedEvent_redactsParameters() throws {
        let secret = "the-secret"
        let event = AnalyticsEvent.errorOccurred(errorCode: secret, screen: .dashboard)

        let sanitized = event.sanitized(secrets: [secret])

        let params = sanitized.parameters
        let paramsStr = params.values.joined(separator: " ")
        XCTAssertFalse(
            paramsStr.contains(secret),
            "Sanitized event params must NOT contain '\(secret)'. Got: \(params). " +
            "BLOCKER: AnalyticsEvent.sanitized(secrets:) returns self without parameter sanitization. " +
            "Implement PiiSanitizer.sanitizeParameters mirroring Android (C-02)."
        )
    }

    // MARK: - Test 4: empty secrets does not redact

    func test_emptySecrets_doesNotRedact() throws {
        let spy = try XCTUnwrap(spy)
        let value = "my-secret-key"
        LoggingManager.shared.updateSecrets([])
        LoggingManager.shared.configure(services: [spy])

        let event = AnalyticsEvent.errorOccurred(errorCode: value, screen: .dashboard)
        LoggingManager.shared.logEvent(event)

        let loggedEvent = spy.capturedEvent
        XCTAssertNotNil(loggedEvent)

        let paramsStr = loggedEvent?.parameters.values.joined(separator: " ") ?? ""
        XCTAssertTrue(
            paramsStr.contains(value),
            "With no secrets registered, event params should pass through unchanged. Got: \(paramsStr)"
        )
    }
}

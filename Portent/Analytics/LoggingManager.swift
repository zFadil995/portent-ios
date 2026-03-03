import Foundation
import Observation

/// Central analytics dispatcher. Forwards events to configured LoggingService implementations;
/// sanitizes PII and secrets before forwarding. Network/API errors are logged as non-fatal.
@Observable
final class LoggingManager {
    static let shared = LoggingManager()
    private var services: [any LoggingService] = []
    private var knownSecrets: Set<String> = []

    func configure(services: [any LoggingService]) {
        self.services = services
    }

    func updateSecrets(_ secrets: Set<String>) {
        knownSecrets = secrets
    }

    func logEvent(_ event: AnalyticsEvent) {
        let sanitized = event.sanitized(secrets: knownSecrets)
        services.forEach { $0.logEvent(sanitized) }
    }

    func logScreen(_ screen: Screen) {
        services.forEach { $0.logScreen(screen) }
        logEvent(.screenViewed(screen: screen))
    }

    func logError(_ error: AppError, context: ErrorContext) {
        let sanitizedOp = PiiSanitizer.sanitize(context.operation, knownSecrets: knownSecrets)
        let sanitizedContext = ErrorContext(screen: context.screen, operation: sanitizedOp)
        services.forEach { $0.logError(error, context: sanitizedContext) }
        switch error {
        case .network, .api:
            services.forEach { $0.logNonFatal(error, context: sanitizedContext) }
        default:
            break
        }
    }

    func setUserProperty(_ property: UserProperty) {
        services.forEach { $0.setUserProperty(property) }
    }

    func startSession() {
        services.forEach { $0.startSession() }
    }

    func endSession() {
        services.forEach { $0.endSession() }
    }
}

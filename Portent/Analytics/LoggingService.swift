import Foundation

/// Protocol for logging services in the composite pattern.
///
/// LoggingManager holds a list of LoggingService implementations and forwards all calls
/// to each. When the user has not opted in to analytics, the list is empty and all
/// calls are immediate no-ops. Opt-in is controlled by AnalyticsOptInManager which
/// configures the list (DebugLogger in debug builds; Firebase loggers in release when opted in).
protocol LoggingService {
    func logEvent(_ event: AnalyticsEvent)
    func logScreen(_ screen: Screen)
    func logError(_ error: AppError, context: ErrorContext)
    func logNonFatal(_ error: AppError, context: ErrorContext)
    func setUserProperty(_ property: UserProperty)
    func startSession()
    func endSession()
}

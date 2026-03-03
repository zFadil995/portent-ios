import Foundation

#if DEBUG

/// Debug-only logger. Prints to console. Only compiled in debug builds.
struct DebugLogger: LoggingService {
    private let tag = "[Portent.Analytics]"

    func logEvent(_ event: AnalyticsEvent) {
        let paramsStr = event.parameters.map { "\($0.key)=\($0.value)" }.joined(separator: ", ")
        print("\(tag) EVENT \(event.name) | \(paramsStr)")
    }

    func logScreen(_ screen: Screen) {
        print("\(tag) SCREEN \(screen.screenName)")
    }

    func logError(_ error: AppError, context: ErrorContext) {
        print("\(tag) ERROR \(error.analyticsCode) | screen=\(context.screen.screenName) op=\(context.operation)")
    }

    func logNonFatal(_ error: AppError, context: ErrorContext) {
        print("\(tag) [NON-FATAL] \(error.analyticsCode) | screen=\(context.screen.screenName) op=\(context.operation)")
    }

    func setUserProperty(_ property: UserProperty) {
        print("\(tag) USER_PROPERTY \(property.key)=\(property.value)")
    }

    func startSession() {
        print("\(tag) SESSION start")
    }

    func endSession() {
        print("\(tag) SESSION end")
    }
}

#endif

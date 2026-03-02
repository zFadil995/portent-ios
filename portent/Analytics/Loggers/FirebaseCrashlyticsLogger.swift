//
//  FirebaseCrashlyticsLogger.swift
//  portent
//

import Foundation

#if canImport(FirebaseCrashlytics)
import FirebaseCrashlytics

struct FirebaseCrashlyticsLogger: LoggingService {
    func logEvent(_ event: AnalyticsEvent) {}
    func logScreen(_ screen: Screen) {}

    func logError(_ error: AppError, context: ErrorContext) {
        Crashlytics.crashlytics().log("ERROR: \(error.analyticsCode)")
    }

    func logNonFatal(_ error: AppError, context: ErrorContext) {
        let analyticsError = AnalyticsError(code: error.analyticsCode, context: context)
        Crashlytics.crashlytics().record(error: analyticsError)
    }

    func setUserProperty(_ property: UserProperty) {
        Crashlytics.crashlytics().setCustomValue(property.value, forKey: property.key)
    }

    func startSession() {}
    func endSession() {}

    private struct AnalyticsError: Error {
        let code: String
        let screenName: String
        let operation: String

        init(code: String, context: ErrorContext) {
            self.code = code
            self.screenName = context.screen.rawValue
            self.operation = context.operation
        }

        var localizedDescription: String { "\(code) | \(screenName) | \(operation)" }
    }
}
#else
struct FirebaseCrashlyticsLogger: LoggingService {
    func logEvent(_ event: AnalyticsEvent) {}
    func logScreen(_ screen: Screen) {}
    func logError(_ error: AppError, context: ErrorContext) {}
    func logNonFatal(_ error: AppError, context: ErrorContext) {}
    func setUserProperty(_ property: UserProperty) {}
    func startSession() {}
    func endSession() {}
}
#endif

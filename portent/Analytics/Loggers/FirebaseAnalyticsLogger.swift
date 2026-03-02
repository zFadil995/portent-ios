//
//  FirebaseAnalyticsLogger.swift
//  portent
//

import Foundation

#if canImport(FirebaseAnalytics)
import FirebaseAnalytics

struct FirebaseAnalyticsLogger: LoggingService {
    func logEvent(_ event: AnalyticsEvent) {
        FirebaseAnalytics.Analytics.logEvent(event.name, parameters: event.parameters)
    }

    func logScreen(_ screen: Screen) {
        FirebaseAnalytics.Analytics.logEvent(
            FirebaseAnalytics.AnalyticsEventScreenView,
            parameters: [FirebaseAnalytics.AnalyticsParameterScreenName: screen.screenName]
        )
    }

    func logError(_ error: AppError, context: ErrorContext) {
        FirebaseAnalytics.Analytics.logEvent("app_error", parameters: ["error_code": error.analyticsCode])
    }

    func logNonFatal(_ error: AppError, context: ErrorContext) {
        // No-op: handled by FirebaseCrashlyticsLogger
    }

    func setUserProperty(_ property: UserProperty) {
        FirebaseAnalytics.Analytics.setUserProperty(property.value, forName: property.key)
    }

    func startSession() {}
    func endSession() {}
}
#else
struct FirebaseAnalyticsLogger: LoggingService {
    func logEvent(_ event: AnalyticsEvent) {}
    func logScreen(_ screen: Screen) {}
    func logError(_ error: AppError, context: ErrorContext) {}
    func logNonFatal(_ error: AppError, context: ErrorContext) {}
    func setUserProperty(_ property: UserProperty) {}
    func startSession() {}
    func endSession() {}
}
#endif

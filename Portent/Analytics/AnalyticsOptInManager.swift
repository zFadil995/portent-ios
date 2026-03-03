//
//  AnalyticsOptInManager.swift
//  portent
//

import Foundation

final class AnalyticsOptInManager {
    static let shared = AnalyticsOptInManager()

    var isOptedIn: Bool {
        get { AppSettingsStorage.shared.analyticsOptIn }
        set { AppSettingsStorage.shared.analyticsOptIn = newValue }
    }

    func setOptIn(_ value: Bool) {
        let wasOptedIn = isOptedIn
        isOptedIn = value
        configureLoggingManager()
        if value && !wasOptedIn {
            let formatter = ISO8601DateFormatter()
            LoggingManager.shared.setUserProperty(.analyticsOptInDate(date: formatter.string(from: Date())))
        }
    }

    private func configureLoggingManager() {
        var services: [any LoggingService] = []
        #if DEBUG
        services.append(DebugLogger())
        #else
        if isOptedIn {
            #if canImport(FirebaseAnalytics) && canImport(FirebaseCrashlytics)
            services.append(FirebaseAnalyticsLogger())
            services.append(FirebaseCrashlyticsLogger())
            #endif
        }
        #endif
        LoggingManager.shared.configure(services: services)
    }

    private init() {
        configureLoggingManager()
    }
}

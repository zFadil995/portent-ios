import Foundation

#if canImport(FirebaseAnalytics)
import FirebaseAnalytics
#endif
#if canImport(FirebaseCrashlytics)
import FirebaseCrashlytics
#endif

/// Manages analytics and Crashlytics opt-in. Gates Firebase collection by user preference;
/// Crashlytics must stay in sync with Analytics for privacy compliance.
final class AnalyticsOptInManager {
    static let shared = AnalyticsOptInManager()

    var isOptedIn: Bool {
        get { AppSettingsStorage.shared.analyticsOptIn }
        set { AppSettingsStorage.shared.analyticsOptIn = newValue }
    }

    func setOptIn(_ value: Bool) {
        let wasOptedIn = isOptedIn
        isOptedIn = value
        #if canImport(FirebaseAnalytics)
        Analytics.setAnalyticsCollectionEnabled(value)
        #endif
        #if canImport(FirebaseCrashlytics)
        // Crashlytics must be gated same as Analytics — privacy requirement
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(value)
        #endif
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
        #if canImport(FirebaseAnalytics)
        // Sync Firebase collection state with stored opt-in preference (portentApp disables at startup first).
        Analytics.setAnalyticsCollectionEnabled(isOptedIn)
        #endif
        #if canImport(FirebaseCrashlytics)
        // Crashlytics must be gated same as Analytics — privacy requirement
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(isOptedIn)
        #endif
        configureLoggingManager()
    }
}

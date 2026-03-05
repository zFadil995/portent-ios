import SwiftUI

#if canImport(FirebaseCore)
import FirebaseCore
#endif
#if canImport(FirebaseAnalytics)
import FirebaseAnalytics
#endif
#if canImport(FirebaseCrashlytics)
import FirebaseCrashlytics
#endif

/// Main app entry point. Configures Firebase (Analytics/Crashlytics) gated by opt-in;
/// both disabled until user consents.
@main
struct PortentApp: App {
    init() {
        #if canImport(FirebaseCore)
        FirebaseApp.configure()
        #endif
        #if canImport(FirebaseCrashlytics)
        // Crashlytics must be gated same as Analytics — privacy requirement
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        #endif
        #if canImport(FirebaseAnalytics)
        // Disable analytics until user opts in; AnalyticsOptInManager enables on opt-in.
        Analytics.setAnalyticsCollectionEnabled(false)
        #endif
        _ = AnalyticsOptInManager.shared
        // Sync PII secrets to LoggingManager for sanitization (per docs/analytics.md)
        syncSecretsToLoggingManager()
        RadarrSecureStorage.shared.onRadarrChanged = { syncSecretsToLoggingManager() }
        SonarrSecureStorage.shared.onSonarrChanged = { syncSecretsToLoggingManager() }
    }

    var body: some Scene {
        WindowGroup {
            AppNavigation()
        }
    }
}

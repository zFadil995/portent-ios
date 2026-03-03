//
//  portentApp.swift
//  portent
//
//  Created by Fadil Žilić on 2. 3. 2026..
//

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
    }

    var body: some Scene {
        WindowGroup {
            // TODO(analytics): configure LoggingManager here once analytics module is wired
            AppNavigation()
        }
    }
}

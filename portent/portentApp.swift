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

@main
struct portentApp: App {
    init() {
        #if canImport(FirebaseCore)
        FirebaseApp.configure()
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

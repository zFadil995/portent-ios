//
//  AppSettingsStorage.swift
//  portent
//
//  Domain-scoped storage for app-level preferences.
//  Stores: theme, default service, onboarding complete, analytics opt-in.
//

import Foundation

final class AppSettingsStorage: SecureStorage {
    static let shared = AppSettingsStorage()

    private convenience init() {
        self.init(store: SecureStore.shared)
    }

    init(store: SecureStoreProtocol) {
        super.init(domain: "app_settings", store: store)
    }

    var theme: String {
        get { read(key: "theme", default: "system") }
        set { write(key: "theme", value: newValue) }
    }

    var defaultServiceId: String {
        get { read(key: "default_service_id", default: "") }
        set { write(key: "default_service_id", value: newValue) }
    }

    var onboardingComplete: Bool {
        get { readBool(key: "onboarding_complete", default: false) }
        set { writeBool(key: "onboarding_complete", value: newValue) }
    }

    var analyticsOptIn: Bool {
        get { readBool(key: "analytics_opt_in", default: false) }
        set { writeBool(key: "analytics_opt_in", value: newValue) }
    }
}

//
//  Screen.swift
//  portent
//

import Foundation

enum Screen: String {
    case dashboard
    case calendar
    case services
    case servicesInstanceDetail = "services_instance_detail"
    case search
    case onboardingAnalyticsOptIn = "onboarding_analytics_opt_in"
    case settings
    case addServiceInstance = "add_service_instance"
    case editServiceInstance = "edit_service_instance"
    case unknown

    var screenName: String { rawValue }
}

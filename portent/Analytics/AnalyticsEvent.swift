//
//  AnalyticsEvent.swift
//  portent
//

import Foundation

enum SearchScope {
    case global
    case sonarr
    case radarr

    var stringValue: String {
        switch self {
        case .global: return "global"
        case .sonarr: return "sonarr"
        case .radarr: return "radarr"
        }
    }
}

enum AnalyticsEvent {
    case serviceAdded(type: ServiceType, isDefault: Bool)
    case serviceEdited(type: ServiceType)
    case serviceDeleted(type: ServiceType)
    case serviceConnectionTested(type: ServiceType, success: Bool)
    case screenViewed(screen: Screen)
    case searchPerformed(scope: SearchScope, resultCount: Int)
    case searchResultSelected(scope: SearchScope, isInLibrary: Bool)
    case episodeSearchTriggered(serviceType: ServiceType)
    case episodeFileDeleted(serviceType: ServiceType)
    case episodeFileDetailsViewed(serviceType: ServiceType)
    case onboardingCompleted(analyticsOptedIn: Bool)
    case analyticsOptInChanged(optedIn: Bool)
    case errorOccurred(errorCode: String, screen: Screen)
    case appForegrounded
    case appBackgrounded

    var name: String {
        switch self {
        case .serviceAdded: return "service_added"
        case .serviceEdited: return "service_edited"
        case .serviceDeleted: return "service_deleted"
        case .serviceConnectionTested: return "service_connection_tested"
        case .screenViewed: return "screen_viewed"
        case .searchPerformed: return "search_performed"
        case .searchResultSelected: return "search_result_selected"
        case .episodeSearchTriggered: return "episode_search_triggered"
        case .episodeFileDeleted: return "episode_file_deleted"
        case .episodeFileDetailsViewed: return "episode_file_details_viewed"
        case .onboardingCompleted: return "onboarding_completed"
        case .analyticsOptInChanged: return "analytics_opt_in_changed"
        case .errorOccurred: return "error_occurred"
        case .appForegrounded: return "app_foregrounded"
        case .appBackgrounded: return "app_backgrounded"
        }
    }

    var parameters: [String: String] {
        switch self {
        case .serviceAdded(let type, let isDefault):
            return ["service_type": type.rawValue.lowercased(), "is_default": String(isDefault)]
        case .serviceEdited(let type):
            return ["service_type": type.rawValue.lowercased()]
        case .serviceDeleted(let type):
            return ["service_type": type.rawValue.lowercased()]
        case .serviceConnectionTested(let type, let success):
            return ["service_type": type.rawValue.lowercased(), "success": String(success)]
        case .screenViewed(let screen):
            return ["screen": screen.screenName]
        case .searchPerformed(let scope, let resultCount):
            return ["scope": scope.stringValue, "result_count": String(resultCount)]
        case .searchResultSelected(let scope, let isInLibrary):
            return ["scope": scope.stringValue, "is_in_library": String(isInLibrary)]
        case .episodeSearchTriggered(let serviceType):
            return ["service_type": serviceType.rawValue.lowercased()]
        case .episodeFileDeleted(let serviceType):
            return ["service_type": serviceType.rawValue.lowercased()]
        case .episodeFileDetailsViewed(let serviceType):
            return ["service_type": serviceType.rawValue.lowercased()]
        case .onboardingCompleted(let analyticsOptedIn):
            return ["analytics_opted_in": String(analyticsOptedIn)]
        case .analyticsOptInChanged(let optedIn):
            return ["opted_in": String(optedIn)]
        case .errorOccurred(let errorCode, let screen):
            return ["error_code": errorCode, "screen": screen.screenName]
        case .appForegrounded, .appBackgrounded:
            return [:]
        }
    }

    func sanitized(secrets: Set<String>) -> AnalyticsEvent {
        self
    }
}

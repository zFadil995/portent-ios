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
        let sanitizedParams = PiiSanitizer.sanitizeParameters(parameters, knownSecrets: secrets)
        if sanitizedParams == parameters { return self }

        switch self {
        case .serviceAdded(let type, let isDefault):
            let st = sanitizedParams["service_type"] ?? type.rawValue.lowercased()
            let id = sanitizedParams["is_default"] ?? String(isDefault)
            return .serviceAdded(
                type: ServiceType(rawValue: st.uppercased()) ?? type,
                isDefault: Bool(id) ?? isDefault
            )
        case .serviceEdited(let type):
            let st = sanitizedParams["service_type"] ?? type.rawValue.lowercased()
            return .serviceEdited(type: ServiceType(rawValue: st.uppercased()) ?? type)
        case .serviceDeleted(let type):
            let st = sanitizedParams["service_type"] ?? type.rawValue.lowercased()
            return .serviceDeleted(type: ServiceType(rawValue: st.uppercased()) ?? type)
        case .serviceConnectionTested(let type, let success):
            let st = sanitizedParams["service_type"] ?? type.rawValue.lowercased()
            let succ = sanitizedParams["success"] ?? String(success)
            return .serviceConnectionTested(
                type: ServiceType(rawValue: st.uppercased()) ?? type,
                success: Bool(succ) ?? success
            )
        case .screenViewed(let screen):
            let sn = sanitizedParams["screen"] ?? screen.screenName
            return .screenViewed(screen: Screen(rawValue: sn) ?? screen)
        case .searchPerformed(let scope, let resultCount):
            let sc = sanitizedParams["scope"] ?? scope.stringValue
            let rc = sanitizedParams["result_count"] ?? String(resultCount)
            return .searchPerformed(
                scope: SearchScope.from(stringValue: sc) ?? scope,
                resultCount: Int(rc) ?? resultCount
            )
        case .searchResultSelected(let scope, let isInLibrary):
            let sc = sanitizedParams["scope"] ?? scope.stringValue
            let iil = sanitizedParams["is_in_library"] ?? String(isInLibrary)
            return .searchResultSelected(
                scope: SearchScope.from(stringValue: sc) ?? scope,
                isInLibrary: Bool(iil) ?? isInLibrary
            )
        case .episodeSearchTriggered(let serviceType):
            let st = sanitizedParams["service_type"] ?? serviceType.rawValue.lowercased()
            return .episodeSearchTriggered(serviceType: ServiceType(rawValue: st.uppercased()) ?? serviceType)
        case .episodeFileDeleted(let serviceType):
            let st = sanitizedParams["service_type"] ?? serviceType.rawValue.lowercased()
            return .episodeFileDeleted(serviceType: ServiceType(rawValue: st.uppercased()) ?? serviceType)
        case .episodeFileDetailsViewed(let serviceType):
            let st = sanitizedParams["service_type"] ?? serviceType.rawValue.lowercased()
            return .episodeFileDetailsViewed(serviceType: ServiceType(rawValue: st.uppercased()) ?? serviceType)
        case .onboardingCompleted(let analyticsOptedIn):
            let aoi = sanitizedParams["analytics_opted_in"] ?? String(analyticsOptedIn)
            return .onboardingCompleted(analyticsOptedIn: Bool(aoi) ?? analyticsOptedIn)
        case .analyticsOptInChanged(let optedIn):
            let oi = sanitizedParams["opted_in"] ?? String(optedIn)
            return .analyticsOptInChanged(optedIn: Bool(oi) ?? optedIn)
        case .errorOccurred(let errorCode, let screen):
            let ec = sanitizedParams["error_code"] ?? errorCode
            let sn = sanitizedParams["screen"] ?? screen.screenName
            return .errorOccurred(errorCode: ec, screen: Screen(rawValue: sn) ?? screen)
        case .appForegrounded, .appBackgrounded:
            return self
        }
    }
}

private extension SearchScope {
    static func from(stringValue: String) -> SearchScope? {
        switch stringValue {
        case "global": return .global
        case "sonarr": return .sonarr
        case "radarr": return .radarr
        default: return nil
        }
    }
}

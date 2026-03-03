import Foundation

/// Search scope for analytics events. Values must match Android for cross-platform reporting.
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

/// Analytics event types sent to Firebase. Event names and parameter keys must match Android.
/// Use `sanitized(secrets:)` before sending to strip PII.
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

    /// Redacts PII from event parameters using PiiSanitizer before sending to analytics.
    func sanitized(secrets: Set<String>) -> AnalyticsEvent {
        let sanitizedParams = PiiSanitizer.sanitizeParameters(parameters, knownSecrets: secrets)
        if sanitizedParams == parameters { return self }

        switch self {
        case .serviceAdded, .serviceEdited, .serviceDeleted, .serviceConnectionTested,
             .episodeSearchTriggered, .episodeFileDeleted, .episodeFileDetailsViewed:
            return Self.reconstructServiceTypeEvent(self, params: sanitizedParams)
        case .searchPerformed, .searchResultSelected:
            return Self.reconstructSearchScopeEvent(self, params: sanitizedParams)
        case .screenViewed, .errorOccurred:
            return Self.reconstructScreenEvent(self, params: sanitizedParams)
        case .onboardingCompleted, .analyticsOptInChanged:
            return Self.reconstructOptInEvent(self, params: sanitizedParams)
        case .appForegrounded, .appBackgrounded:
            return self
        }
    }

    private static func reconstructServiceTypeEvent(
        _ event: AnalyticsEvent, params: [String: String]
    ) -> AnalyticsEvent {
        switch event {
        case .serviceAdded(let type, let isDefault):
            let serviceType = parseServiceType(params, key: "service_type", fallback: type)
            let isDefaultValue = parseBool(params, key: "is_default", fallback: isDefault)
            return .serviceAdded(type: serviceType, isDefault: isDefaultValue)
        case .serviceConnectionTested(let type, let success):
            let serviceType = parseServiceType(params, key: "service_type", fallback: type)
            let successValue = parseBool(params, key: "success", fallback: success)
            return .serviceConnectionTested(type: serviceType, success: successValue)
        case .serviceEdited(let type):
            return .serviceEdited(type: parseServiceType(params, key: "service_type", fallback: type))
        case .serviceDeleted(let type):
            return .serviceDeleted(type: parseServiceType(params, key: "service_type", fallback: type))
        case .episodeSearchTriggered(let serviceType):
            return .episodeSearchTriggered(
                serviceType: parseServiceType(params, key: "service_type", fallback: serviceType)
            )
        case .episodeFileDeleted(let serviceType):
            return .episodeFileDeleted(
                serviceType: parseServiceType(params, key: "service_type", fallback: serviceType)
            )
        case .episodeFileDetailsViewed(let serviceType):
            return .episodeFileDetailsViewed(
                serviceType: parseServiceType(params, key: "service_type", fallback: serviceType)
            )
        default:
            return event
        }
    }

    private static func reconstructSearchScopeEvent(
        _ event: AnalyticsEvent, params: [String: String]
    ) -> AnalyticsEvent {
        switch event {
        case .searchPerformed(let scope, let resultCount):
            let searchScope = parseSearchScope(params, key: "scope", fallback: scope)
            let resultCountValue = parseInt(params, key: "result_count", fallback: resultCount)
            return .searchPerformed(scope: searchScope, resultCount: resultCountValue)
        case .searchResultSelected(let scope, let isInLibrary):
            let searchScope = parseSearchScope(params, key: "scope", fallback: scope)
            let isInLibraryValue = parseBool(params, key: "is_in_library", fallback: isInLibrary)
            return .searchResultSelected(scope: searchScope, isInLibrary: isInLibraryValue)
        default:
            return event
        }
    }

    private static func reconstructScreenEvent(
        _ event: AnalyticsEvent, params: [String: String]
    ) -> AnalyticsEvent {
        switch event {
        case .screenViewed(let screen):
            let screenName = params["screen"] ?? screen.screenName
            return .screenViewed(screen: Screen(rawValue: screenName) ?? screen)
        case .errorOccurred(let errorCode, let screen):
            let errorCodeValue = params["error_code"] ?? errorCode
            let screenName = params["screen"] ?? screen.screenName
            return .errorOccurred(errorCode: errorCodeValue, screen: Screen(rawValue: screenName) ?? screen)
        default:
            return event
        }
    }

    private static func reconstructOptInEvent(
        _ event: AnalyticsEvent, params: [String: String]
    ) -> AnalyticsEvent {
        switch event {
        case .onboardingCompleted(let analyticsOptedIn):
            let value = parseBool(params, key: "analytics_opted_in", fallback: analyticsOptedIn)
            return .onboardingCompleted(analyticsOptedIn: value)
        case .analyticsOptInChanged(let optedIn):
            let value = parseBool(params, key: "opted_in", fallback: optedIn)
            return .analyticsOptInChanged(optedIn: value)
        default:
            return event
        }
    }

    private static func parseServiceType(
        _ params: [String: String], key: String, fallback: ServiceType
    ) -> ServiceType {
        let raw = params[key] ?? fallback.rawValue.lowercased()
        return ServiceType(rawValue: raw.uppercased()) ?? fallback
    }

    private static func parseSearchScope(
        _ params: [String: String], key: String, fallback: SearchScope
    ) -> SearchScope {
        let raw = params[key] ?? fallback.stringValue
        return SearchScope.from(stringValue: raw) ?? fallback
    }

    private static func parseBool(_ params: [String: String], key: String, fallback: Bool) -> Bool {
        let raw = params[key] ?? String(fallback)
        return Bool(raw) ?? fallback
    }

    private static func parseInt(_ params: [String: String], key: String, fallback: Int) -> Int {
        let raw = params[key] ?? String(fallback)
        return Int(raw) ?? fallback
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

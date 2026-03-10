import SwiftUI

/// Tab definitions for the four main tabs. Must match Android tab order and labels.
enum TabDestination: String, CaseIterable, Identifiable {
    case dashboard
    case calendar
    case services
    case search

    var id: String { rawValue }

    var label: String {
        switch self {
        case .dashboard: return String(localized: "tab_dashboard")
        case .calendar: return String(localized: "tab_calendar")
        case .services: return String(localized: "tab_services")
        case .search: return String(localized: "tab_search")
        }
    }

    var systemImage: String {
        switch self {
        case .dashboard: return "house"
        case .calendar: return "calendar"
        case .services: return "server.rack"
        case .search: return "magnifyingglass"
        }
    }
}

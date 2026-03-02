//
//  TabDestination.swift
//  portent
//

import SwiftUI

enum TabDestination: String, CaseIterable, Identifiable {
    case dashboard
    case calendar
    case services
    case search

    var id: String { rawValue }

    var label: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .calendar: return "Calendar"
        case .services: return "Services"
        case .search: return "Search"
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

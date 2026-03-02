//
//  AppNavigation.swift
//  portent
//

import SwiftUI

struct AppNavigation: View {
    var body: some View {
        TabView {
            Tab(TabDestination.dashboard.label, systemImage: TabDestination.dashboard.systemImage) {
                NavigationStack {
                    DashboardView()
                }
            }
            Tab(TabDestination.calendar.label, systemImage: TabDestination.calendar.systemImage) {
                NavigationStack {
                    CalendarView()
                }
            }
            Tab(TabDestination.services.label, systemImage: TabDestination.services.systemImage) {
                NavigationStack {
                    ServicesView()
                }
            }
            Tab(TabDestination.search.label, systemImage: TabDestination.search.systemImage) {
                NavigationStack {
                    SearchView()
                }
            }
        }
        .appTheme()
    }
}

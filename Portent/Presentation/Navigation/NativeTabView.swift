import SwiftUI

struct NativeTabView: View {
    @State private var searchText = ""

    var body: some View {
        TabView {
            Tab(TabDestination.dashboard.label, systemImage: TabDestination.dashboard.systemImage) {
                NavigationStack { DashboardView() }
            }
            Tab(TabDestination.calendar.label, systemImage: TabDestination.calendar.systemImage) {
                NavigationStack { CalendarView() }
            }
            Tab(TabDestination.services.label, systemImage: TabDestination.services.systemImage) {
                NavigationStack { ServicesView() }
            }
            Tab(TabDestination.search.label, systemImage: TabDestination.search.systemImage, role: .search) {
                NavigationStack {
                    SearchView()
                        .navigationTitle("Search")
                }
                .searchable(text: $searchText, prompt: "Search")
            }
        }
        .appTheme()
    }
}

import SwiftUI

/// Host view for Calendar. Owns ViewModel and passes state to CalendarViewContents.
struct CalendarView: View {
    @State private var viewModel = CalendarViewModel()

    var body: some View {
        CalendarViewContents(
            state: viewModel.state,
            onRefresh: { viewModel.refresh() }
        )
    }
}

/// Stateless Calendar UI. Receives state and actions; no ViewModel.
struct CalendarViewContents: View {
    let state: UiState<CalendarState>
    let onRefresh: () -> Void

    var body: some View {
        switch state {
        case .loading:
            ProgressView()
                .accessibilityLabel("common_loading")
        case .refreshing(let staleData):
            calendarContent(staleData)
                .overlay(alignment: .top) {
                    ProgressView()
                        .accessibilityLabel("common_loading")
                        .padding(.top, LayoutConstants.RefreshOverlay.topPadding)
                }
        case .success(let data):
            calendarContent(data)
        case .error(let appError):
            ContentUnavailableView(
                "screen_error_title",
                systemImage: "exclamationmark.triangle",
                description: Text(appError.toUserMessage())
            )
        }
    }

    @ViewBuilder
    private func calendarContent(_ data: CalendarState) -> some View {
        ContentUnavailableView(
            "tab_calendar",
            systemImage: "calendar",
            description: Text("screen_coming_soon")
        )
    }
}

#Preview {
    CalendarViewContents(
        state: .success(CalendarState()),
        onRefresh: {}
    )
}

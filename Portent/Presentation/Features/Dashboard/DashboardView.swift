import SwiftUI

/// Host view for Dashboard. Owns ViewModel and passes state to DashboardViewContents.
struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()

    var body: some View {
        DashboardViewContents(
            state: viewModel.state,
            onRefresh: { viewModel.refresh() }
        )
    }
}

/// Stateless Dashboard UI. Receives state and actions; no ViewModel.
struct DashboardViewContents: View {
    let state: UiState<DashboardState>
    let onRefresh: () -> Void

    var body: some View {
        switch state {
        case .loading:
            ProgressView()
        case .refreshing(let staleData):
            dashboardContent(staleData)
                .overlay(alignment: .top) {
                    ProgressView()
                        .padding(.top, 8)
                }
        case .success(let data):
            dashboardContent(data)
        case .error(let appError):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(appError.toUserMessage())
            )
        }
    }

    @ViewBuilder
    private func dashboardContent(_ data: DashboardState) -> some View {
        ContentUnavailableView(
            "Dashboard",
            systemImage: "house",
            description: Text("Coming soon")
        )
    }
}

#Preview {
    DashboardViewContents(
        state: .success(DashboardState()),
        onRefresh: {}
    )
}

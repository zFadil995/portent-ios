import SwiftUI

/// Host view for Services. Owns ViewModel and passes state to ServicesViewContents.
struct ServicesView: View {
    @State private var viewModel = ServicesViewModel()

    var body: some View {
        ServicesViewContents(
            state: viewModel.state,
            onRefresh: { viewModel.refresh() }
        )
    }
}

/// Stateless Services UI. Receives state and actions; no ViewModel.
struct ServicesViewContents: View {
    let state: UiState<ServicesState>
    let onRefresh: () -> Void

    var body: some View {
        switch state {
        case .loading:
            ProgressView()
        case .refreshing(let staleData):
            servicesContent(staleData)
                .overlay(alignment: .top) {
                    ProgressView()
                        .padding(.top, 8)
                }
        case .success(let data):
            servicesContent(data)
        case .error(let appError):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(appError.toUserMessage())
            )
        }
    }

    @ViewBuilder
    private func servicesContent(_ data: ServicesState) -> some View {
        ContentUnavailableView(
            "Services",
            systemImage: "server.rack",
            description: Text("Coming soon")
        )
    }
}

#Preview {
    ServicesViewContents(
        state: .success(ServicesState()),
        onRefresh: {}
    )
}

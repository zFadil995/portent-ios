import SwiftUI

/// Host view for Search. Owns ViewModel and passes state to SearchViewContents.
struct SearchView: View {
    @State private var viewModel = SearchViewModel()

    var body: some View {
        SearchViewContents(
            state: viewModel.state,
            onRefresh: { viewModel.refresh() }
        )
    }
}

/// Stateless Search UI. Receives state and actions; no ViewModel.
/// Contract: Refreshing(staleData) shows stale content with subtle loading indicator, not full-screen ProgressView.
struct SearchViewContents: View {
    let state: UiState<SearchState>
    let onRefresh: () -> Void

    var body: some View {
        switch state {
        case .loading:
            ProgressView()
        case .refreshing(let staleData):
            searchContent(staleData)
                .overlay(alignment: .top) {
                    ProgressView()
                        .padding(.top, 8)
                }
        case .success(let data):
            searchContent(data)
        case .error(let appError):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(String(describing: appError))
            )
        }
    }

    @ViewBuilder
    private func searchContent(_ data: SearchState) -> some View {
        ContentUnavailableView(
            "Search",
            systemImage: "magnifyingglass",
            description: Text("Coming soon")
        )
    }
}

#Preview {
    SearchViewContents(
        state: .success(SearchState()),
        onRefresh: {}
    )
}

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
struct SearchViewContents: View {
    let state: UiState<SearchState>
    let onRefresh: () -> Void

    var body: some View {
        switch state {
        case .loading, .refreshing:
            ProgressView()
        case .success:
            ContentUnavailableView(
                "Search",
                systemImage: "magnifyingglass",
                description: Text("Coming soon")
            )
        case .error(let appError):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(String(describing: appError))
            )
        }
    }
}

#Preview {
    SearchViewContents(
        state: .success(SearchState()),
        onRefresh: {}
    )
}

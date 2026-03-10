import SwiftUI

/// Host view for Search. Owns ViewModel and passes state to SearchViewContents.
/// Accepts a searchText binding from the parent TabView so the system search bar
/// feeds into the ViewModel (iOS uses .searchable at the NavigationStack level).
struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    @Binding var searchText: String

    var body: some View {
        SearchViewContents(
            state: viewModel.state,
            onRefresh: { viewModel.refresh() }
        )
        .onChange(of: searchText) { _, newValue in
            viewModel.onQueryChange(newValue)
        }
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
                .accessibilityLabel("common_loading")
        case .refreshing(let staleData):
            searchContent(staleData, isLoading: true)
                .overlay(alignment: .top) {
                    ProgressView()
                        .accessibilityLabel("common_loading")
                        .padding(.top, LayoutConstants.RefreshOverlay.topPadding)
                }
        case .success(let data):
            searchContent(data, isLoading: false)
        case .error(let appError):
            ContentUnavailableView(
                "screen_error_title",
                systemImage: "exclamationmark.triangle",
                description: Text(appError.toUserMessage())
            )
        }
    }

    @ViewBuilder
    private func searchContent(_ data: SearchState, isLoading: Bool) -> some View {
        if isLoading {
            ProgressView()
                .accessibilityLabel("common_loading")
        } else {
            ContentUnavailableView(
                "search_empty_title",
                systemImage: "magnifyingglass",
                description: Text("search_empty_subtitle")
            )
        }
    }
}

#Preview("Empty state") {
    SearchViewContents(
        state: .success(SearchState()),
        onRefresh: {}
    )
}

#Preview("Error state") {
    SearchViewContents(
        state: .error(.network(.unreachable)),
        onRefresh: {}
    )
}

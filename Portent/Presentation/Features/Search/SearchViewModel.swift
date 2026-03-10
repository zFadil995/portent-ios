import Foundation

/// State payload for Search screen. Aligned with Android SearchState for cross-platform parity.
struct SearchState: Sendable {
    var query: String = ""
    // Placeholder; add results, filteredSuggestions, etc. when search API is wired.
}

/// ViewModel for Search screen. Matches Android SearchViewModel parity.
/// Stub methods until search API is implemented in Phase C.
@MainActor
@Observable
final class SearchViewModel {
    var state: UiState<SearchState> = .success(SearchState())

    func refresh() {
        // Stub: will load searchable instances and results when API is wired.
        // TODO: When API is wired, transition to .refreshing(staleData: state.dataOrNil ?? SearchState())
        // before the async call, then to .success(newData) on completion. Contract: Refreshing shows stale data.
        state = .success(state.dataOrNil ?? SearchState())
    }

    func onQueryChange(_ query: String) {
        // Stub: will filter suggestions or trigger search when API is wired.
        if var current = state.dataOrNil {
            current.query = query
            state = .success(current)
        }
    }

    func search(query: String) {
        // Stub: will call Radarr/Sonarr search when API is wired.
        onQueryChange(query)
    }
}

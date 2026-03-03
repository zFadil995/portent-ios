import Foundation

/// Placeholder state for Search screen. Will hold results when CRUD/search is implemented.
struct SearchState: Sendable {
    // Placeholder; add results, query, etc. when search API is wired.
}

/// ViewModel for Search screen. Matches Android SearchViewModel parity.
/// Stub methods until search API is implemented.
@MainActor
@Observable
final class SearchViewModel {
    var state: UiState<SearchState> = .success(SearchState())

    func refresh() {
        // Stub: will load searchable instances and results when API is wired.
        state = .success(SearchState())
    }

    func search(query: String) {
        // Stub: will call Radarr/Sonarr search when API is wired.
        _ = query
        state = .success(SearchState())
    }
}

import Foundation

/// Placeholder state for Services screen. Will hold instances, etc. when API is wired.
struct ServicesState: Sendable {
    // Placeholder; add instances, etc. when services API is wired.
}

/// ViewModel for Services screen. Matches Android ServicesViewModel parity.
/// Stub methods until services API is implemented.
@MainActor
@Observable
final class ServicesViewModel {
    var state: UiState<ServicesState> = .success(ServicesState())

    func refresh() {
        // Stub: will load instances when API is wired.
        // TODO: When API is wired, transition to .refreshing(staleData) before async call.
        state = .success(ServicesState())
    }
}

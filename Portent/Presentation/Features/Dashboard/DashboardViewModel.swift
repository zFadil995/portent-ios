import Foundation

/// Placeholder state for Dashboard screen. Will hold queue, activity, etc. when API is wired.
struct DashboardState: Sendable {
    // Placeholder; add queue, activity, etc. when dashboard API is wired.
}

/// ViewModel for Dashboard screen. Matches Android DashboardViewModel parity.
/// Stub methods until dashboard API is implemented.
@MainActor
@Observable
final class DashboardViewModel {
    var state: UiState<DashboardState> = .success(DashboardState())

    func refresh() {
        // Stub: will load queue/activity when API is wired.
        // TODO: When API is wired, transition to .refreshing(staleData) before async call.
        state = .success(DashboardState())
    }
}

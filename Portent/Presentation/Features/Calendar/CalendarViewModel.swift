import Foundation

/// Placeholder state for Calendar screen. Will hold episodes, dates, etc. when API is wired.
struct CalendarState: Sendable {
    // Placeholder; add episodes, dates, etc. when calendar API is wired.
}

/// ViewModel for Calendar screen. Matches Android CalendarViewModel parity.
/// Stub methods until calendar API is implemented.
@MainActor
@Observable
final class CalendarViewModel {
    var state: UiState<CalendarState> = .success(CalendarState())

    func refresh() {
        // Stub: will load calendar data when API is wired.
        // TODO: When API is wired, transition to .refreshing(staleData) before async call.
        state = .success(CalendarState())
    }
}

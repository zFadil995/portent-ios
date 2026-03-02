//
//  UiState.swift
//  portent
//

import Foundation

/// Sealed UI state used across all ViewModels.
/// Refreshing carries stale data visible while a refresh is in progress.
enum UiState<T> {
    case loading
    case success(T)
    case error(AppError)
    case refreshing(staleData: T)
}

extension UiState {
    /// True if loading or refreshing
    var isLoading: Bool {
        switch self {
        case .loading, .refreshing: return true
        default: return false
        }
    }

    /// Extract data from success or refreshing, nil otherwise
    var dataOrNil: T? {
        switch self {
        case .success(let data): return data
        case .refreshing(let data): return data
        default: return nil
        }
    }
}

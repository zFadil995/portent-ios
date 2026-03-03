/// Legacy loading-state enum. Use `UiState` for all new screens.
enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case error(title: String? = nil, message: String?)
}

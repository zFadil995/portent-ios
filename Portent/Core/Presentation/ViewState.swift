// Use ViewState for all new screens going forward. Existing screens use direct @Observable properties — do not migrate those.
enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case error(title: String? = nil, message: String?)
}

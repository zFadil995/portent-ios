import Foundation

/// Screen and operation context for error analytics. Used when reporting errors to Crashlytics.
struct ErrorContext {
    let screen: Screen
    let operation: String
}

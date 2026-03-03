import SwiftUI

/// Minimal theme modifier. v1: follows system color scheme.
/// Future: user preference for light/dark/system.
struct AppThemeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func appTheme() -> some View {
        modifier(AppThemeModifier())
    }
}

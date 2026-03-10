import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

private enum HexColorParsing {
    static let fullAlpha: UInt64 = 255
    static let shortLength = 3
    static let rgbLength = 6
    static let rgbaLength = 8
    static let shortMultiplier: UInt64 = 17
    static let shortRedShift = 8
    static let shortGreenShift = 4
    static let redShift = 16
    static let greenShift = 8
    static let alphaShift = 24
    static let byteMask: UInt64 = 0xFF
    static let nibbleMask: UInt64 = 0xF
    static let sRGBDivisor: Double = 255
}

extension Color {
    /// Dynamic color that resolves to light or dark based on interface style.
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self = Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
        #elseif canImport(AppKit)
        self = Color(NSColor(name: nil) { appearance in
            switch appearance.bestMatch(from: [.darkAqua, .aqua]) {
            case .darkAqua?:
                return NSColor(dark)
            default:
                return NSColor(light)
            }
        })
        #else
        self = light
        #endif
    }

    /// Creates a color from a hex string (#RRGGBB or #RGB).
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case HexColorParsing.shortLength:
            (alpha, red, green, blue) = (
                HexColorParsing.fullAlpha,
                (int >> HexColorParsing.shortRedShift) * HexColorParsing.shortMultiplier,
                (int >> HexColorParsing.shortGreenShift & HexColorParsing.nibbleMask) * HexColorParsing.shortMultiplier,
                (int & HexColorParsing.nibbleMask) * HexColorParsing.shortMultiplier
            )
        case HexColorParsing.rgbLength:
            (alpha, red, green, blue) = (
                HexColorParsing.fullAlpha,
                int >> HexColorParsing.redShift,
                int >> HexColorParsing.greenShift & HexColorParsing.byteMask,
                int & HexColorParsing.byteMask
            )
        case HexColorParsing.rgbaLength:
            (alpha, red, green, blue) = (
                int >> HexColorParsing.alphaShift,
                int >> HexColorParsing.redShift & HexColorParsing.byteMask,
                int >> HexColorParsing.greenShift & HexColorParsing.byteMask,
                int & HexColorParsing.byteMask
            )
        default:
            (alpha, red, green, blue) = (HexColorParsing.fullAlpha, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(red) / HexColorParsing.sRGBDivisor,
            green: Double(green) / HexColorParsing.sRGBDivisor,
            blue: Double(blue) / HexColorParsing.sRGBDivisor,
            opacity: Double(alpha) / HexColorParsing.sRGBDivisor
        )
    }

    static let portentPrimary = Color(
        light: Color(hex: "#1C1B4B"),
        dark: Color(hex: "#A8A4FF")
    )
    static let portentBackground = Color(
        light: Color(hex: "#F5F5F7"),
        dark: Color(hex: "#0A0918")
    )
    static let portentSurface = Color(
        light: .white,
        dark: Color(hex: "#1C1B2E")
    )
    static let portentError = Color(
        light: Color(hex: "#BA1A1A"),
        dark: Color(hex: "#FFB4AB")
    )
    static let portentOnPrimary = Color(
        light: .white,
        dark: Color(hex: "#1C1B4B")
    )
    static let portentOnBackground = Color(
        light: Color(hex: "#1C1B2E"),
        dark: Color(hex: "#E6E1E5")
    )
    static let portentOnSurface = Color(
        light: Color(hex: "#1C1B2E"),
        dark: Color(hex: "#E6E1E5")
    )
    static let portentSecondary = Color(
        light: Color(hex: "#5C5A6F"),
        dark: Color(hex: "#CAC4D0")
    )
    static let portentOnSecondary = Color(
        light: .white,
        dark: Color(hex: "#2D2B3E")
    )
    static let portentSurfaceVariant = Color(
        light: Color(hex: "#E7E0EC"),
        dark: Color(hex: "#49454F")
    )
    static let portentOnSurfaceVariant = Color(
        light: Color(hex: "#49454F"),
        dark: Color(hex: "#CAC4D0")
    )
    static let portentOnError = Color(
        light: .white,
        dark: Color(hex: "#690005")
    )
}

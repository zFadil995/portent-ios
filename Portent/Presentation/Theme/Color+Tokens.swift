//
//  Color+Tokens.swift
//  portent
//

import SwiftUI
import UIKit

extension Color {
    /// Dynamic color that resolves to light or dark based on interface style.
    init(light: Color, dark: Color) {
        self = Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }

    /// Creates a color from a hex string (#RRGGBB or #RGB).
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3:
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }

    // TODO(design): Replace with final brand colors

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

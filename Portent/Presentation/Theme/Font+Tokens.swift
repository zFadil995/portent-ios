//
//  Font+Tokens.swift
//  portent
//

import SwiftUI

extension Font {
    // TODO(design): Replace with brand typography if needed

    static let portentTitle = Font.system(.title, design: .default, weight: .bold)
    static let portentHeadline = Font.system(.headline, design: .default, weight: .semibold)
    static let portentBody = Font.system(.body, design: .default, weight: .regular)
    static let portentCaption = Font.system(.caption, design: .default, weight: .regular)
}

//
//  PiiSanitizer.swift
//  portent
//

import Foundation

struct PiiSanitizer {
    static func sanitize(_ input: String, knownSecrets: Set<String>) -> String {
        var result = input
        for secret in knownSecrets {
            if !secret.trimmingCharacters(in: .whitespaces).isEmpty {
                result = result.replacingOccurrences(of: secret, with: "[REDACTED]")
            }
        }
        return result
    }

    static func sanitizeParameters(
        _ params: [String: String],
        knownSecrets: Set<String>
    ) -> [String: String] {
        params.mapValues { sanitize($0, knownSecrets: knownSecrets) }
    }
}

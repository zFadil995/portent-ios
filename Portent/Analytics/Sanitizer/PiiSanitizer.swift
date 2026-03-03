import Foundation

/// Redacts known secrets from strings and parameter dictionaries before logging or analytics.
/// Use with knownSecrets from SecureStore key names and other sensitive identifiers.
struct PiiSanitizer {
    nonisolated static func sanitize(_ input: String, knownSecrets: Set<String>) -> String {
        var result = input
        for secret in knownSecrets where !secret.trimmingCharacters(in: .whitespaces).isEmpty {
            result = result.replacingOccurrences(of: secret, with: "[REDACTED]")
        }
        return result
    }

    nonisolated static func sanitizeParameters(
        _ params: [String: String],
        knownSecrets: Set<String>
    ) -> [String: String] {
        params.mapValues { sanitize($0, knownSecrets: knownSecrets) }
    }
}

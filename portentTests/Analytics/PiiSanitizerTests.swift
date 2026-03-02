//
//  PiiSanitizerTests.swift
//  portentTests
//

import XCTest
@testable import portent

final class PiiSanitizerTests: XCTestCase {

    func test_replacesKnownApiKeyWithRedacted() {
        let apiKey = "secret-api-key-123"
        let input = "Error: Invalid API key \(apiKey)"
        let result = PiiSanitizer.sanitize(input, knownSecrets: [apiKey])
        XCTAssertEqual(result, "Error: Invalid API key [REDACTED]")
    }

    func test_replacesBaseUrlWithRedacted() {
        let baseUrl = "https://sonarr.example.com:8989"
        let input = "Connection failed to \(baseUrl)"
        let result = PiiSanitizer.sanitize(input, knownSecrets: [baseUrl])
        XCTAssertEqual(result, "Connection failed to [REDACTED]")
    }

    func test_blankSecretsDoNotCauseAccidentalRedaction() {
        let input = "Some message with empty"
        let result = PiiSanitizer.sanitize(input, knownSecrets: ["", "   "])
        XCTAssertEqual(result, input)
    }

    func test_sanitizeParametersSanitizesAllValues() {
        let apiKey = "my-secret-key"
        let params: [String: String] = [
            "error": "Auth failed with key \(apiKey)",
            "url": "https://example.com"
        ]
        let secrets: Set<String> = [apiKey, "https://example.com"]
        let result = PiiSanitizer.sanitizeParameters(params, knownSecrets: secrets)
        XCTAssertEqual(result["error"], "Auth failed with key [REDACTED]")
        XCTAssertEqual(result["url"], "[REDACTED]")
    }
}

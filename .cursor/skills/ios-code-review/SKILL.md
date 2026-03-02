---
name: ios-code-review
description: Review iOS code for architecture compliance, Swift idioms, SwiftUI patterns, concurrency safety, and test coverage. Use when reviewing iOS features or pull requests.
---

# iOS Code Review

## Checklist

- Architecture: Presentation→Domain, Data→Domain; Service protocol in domain
- Swift: No force unwrap, struct over class, Swift 6 concurrency
- SwiftUI: View decomposition, .task not onAppear, #Preview with mocks
- Concurrency: @MainActor for UI, Sendable where needed
- Networking: AppError mapping, per-instance config
- Error handling: AppError in ViewModel, .alert presentation
- Security: Keychain for credentials, ATS config
- Tests: Naming, fakes, @MainActor for ViewModel tests
- macOS: Layout considerations where applicable

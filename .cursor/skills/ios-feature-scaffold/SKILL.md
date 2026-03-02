---
name: ios-feature-scaffold
description: Scaffold a new iOS feature with MVVM architecture using @Observable. Use when creating new features or feature directories in the iOS app.
---

# iOS Feature Scaffold

## Steps

1. Create `Features/<Name>/Data/` — Service impl, DTOs
2. Create `Features/<Name>/Domain/` — Service protocol, UseCase (optional)
3. Create `Features/<Name>/Presentation/` — ViewModel, View, State
4. ViewModel stub: @Observable, state, load(), action methods
5. View stub: observes ViewModel, .task { await viewModel.load() }
6. Test stub: @Test, @MainActor for ViewModel
7. Register navigation destination
8. macOS: consider NavigationSplitView for sidebar
9. Update docs/testing-strategy.md parity table

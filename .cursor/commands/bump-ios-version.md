# Bump iOS Version

Bump CFBundleVersion and CFBundleShortVersionString in the version manifest and Xcode project.

1. Read version.json from mono root (version, ios_build)
2. Increment per argument: major, minor, patch
3. Update version.json (version, ios_build)
4. Update `Portent.xcodeproj/project.pbxproj` build settings (MARKETING_VERSION, CURRENT_PROJECT_VERSION)

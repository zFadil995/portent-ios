# Bump iOS Version

Bump CFBundleVersion and CFBundleShortVersionString in xcconfig and the version manifest.

1. Read version.json from mono root
2. Increment per argument: major, minor, patch
3. Update version.json
4. Run sync-version.sh or update Version.xcconfig

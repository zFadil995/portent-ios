//
//  SecureStoreError.swift
//  portent
//

import Foundation

/// Errors thrown by SecureStore Keychain operations.
enum SecureStoreError: Error {
    case notInitialized
    case writeFailed(OSStatus)
    case readFailed(OSStatus)
    case deleteFailed(OSStatus)
    case dataCorrupted
    case unsupportedType
}

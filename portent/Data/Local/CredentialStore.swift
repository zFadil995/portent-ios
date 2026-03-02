//
//  CredentialStore.swift
//  portent
//

import Foundation

/// Abstraction over secure credential storage.
/// Implementation stores ServiceInstance credentials in Keychain.
/// Domain layer — no UIKit/SwiftUI imports.
protocol CredentialStore {
    func saveInstance(_ instance: ServiceInstance) async throws
    func getInstances() async throws -> [ServiceInstance]
    func getInstanceById(_ id: UUID) async throws -> ServiceInstance?
    func deleteInstance(id: UUID) async throws
    func updateInstance(_ instance: ServiceInstance) async throws
}

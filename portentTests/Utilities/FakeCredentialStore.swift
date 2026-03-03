//
//  FakeCredentialStore.swift
//  portentTests
//
// TODO: Add tests using FakeCredentialStore when CredentialStore
// has more logic to test (e.g., key construction, error mapping).
// Do not delete — required as a test double for upcoming API tests.

import Foundation
@testable import Portent

final class FakeCredentialStore: CredentialStore {
    private(set) var instances: [ServiceInstance] = []

    func saveInstance(_ instance: ServiceInstance) async throws {
        instances.append(instance)
    }

    func getInstances() async throws -> [ServiceInstance] {
        instances
    }

    func getInstanceById(_ id: UUID) async throws -> ServiceInstance? {
        instances.first { $0.id == id }
    }

    func deleteInstance(id: UUID) async throws {
        instances.removeAll { $0.id == id }
    }

    func updateInstance(_ instance: ServiceInstance) async throws {
        guard let index = instances.firstIndex(where: { $0.id == instance.id }) else { return }
        instances[index] = instance
    }

    func reset() {
        instances.removeAll()
    }
}

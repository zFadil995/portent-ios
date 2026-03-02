//
//  FakeCredentialStore.swift
//  portentTests
//

import Foundation
@testable import portent

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

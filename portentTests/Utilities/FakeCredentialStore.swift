// Test double for CredentialStore. Kept for upcoming API tests; add tests when
// CredentialStore gains key construction, error mapping, or other logic to exercise.

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

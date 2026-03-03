// Demonstrates FakeCredentialStore usage for ViewModel tests.
// When AddInstanceViewModel or similar ViewModels exist, inject FakeCredentialStore
// to test save/get/delete flows without real Keychain.

import Foundation
import XCTest
@testable import Portent

@MainActor
final class FakeCredentialStoreTests: XCTestCase {

    func test_saveInstance_getInstances_returnsSaved() async throws {
        let fake = FakeCredentialStore()
        let instance = ServiceInstance(
            id: UUID(),
            type: .radarr,
            name: "My Radarr",
            baseUrl: "https://radarr.local",
            apiKey: "secret",
            isDefault: true,
            ignoreSslErrors: false,
            isSearchable: true
        )

        try await fake.saveInstance(instance)

        let instances = try await fake.getInstances()
        XCTAssertEqual(instances.count, 1)
        XCTAssertEqual(instances[0].id, instance.id)
        XCTAssertEqual(instances[0].name, "My Radarr")
    }

    func test_getInstanceById_whenExists_returnsInstance() async throws {
        let fake = FakeCredentialStore()
        let id = UUID()
        let instance = ServiceInstance(
            id: id,
            type: .sonarr,
            name: "Sonarr",
            baseUrl: "https://sonarr.local",
            apiKey: "key",
            isDefault: false,
            ignoreSslErrors: false,
            isSearchable: true
        )
        try await fake.saveInstance(instance)

        let found = try await fake.getInstanceById(id)
        XCTAssertNotNil(found)
        XCTAssertEqual(found?.id, instance.id)
    }

    func test_deleteInstance_removesFromStore() async throws {
        let fake = FakeCredentialStore()
        let id = UUID()
        let instance = ServiceInstance(
            id: id,
            type: .radarr,
            name: "To Delete",
            baseUrl: "https://x.local",
            apiKey: "k",
            isDefault: false,
            ignoreSslErrors: false,
            isSearchable: true
        )
        try await fake.saveInstance(instance)

        try await fake.deleteInstance(id: id)

        let found = try await fake.getInstanceById(id)
        XCTAssertNil(found)
        let instances = try await fake.getInstances()
        XCTAssertTrue(instances.isEmpty)
    }
}

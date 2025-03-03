// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DataManagement",
    platforms: [.iOS(.v18)],
    products: [
        CachingInterface.library,
        CachingImplementations.library,
        Providers.library,
    ],
    dependencies: [
        Packages.networking,
        Packages.model,
    ],
    targets: [
        CachingInterface.target,
        CachingImplementations.target,
        CachingImplementations.testTarget,
        Providers.target,
        Providers.testTarget,
    ]
)

// MARK: - Caching

enum CachingInterface {
    private static let name = "CachingInterface"
    static let library = Product.library(name: name, targets: [name])
    static let target = Target.target(name: name)
    static let dependency = Target.Dependency.byName(name: name)
}

enum CachingImplementations {
    private static let name = "CachingImplementations"
    static let library = Product.library(name: name, targets: [name])
    static let target = Target.target(
        name: name,
        dependencies: [CachingInterface.dependency]
    )
    static let testTarget = Target.testTarget(
        name: name.tests,
        dependencies: [
            dependency,
            CachingInterface.dependency,
        ]
    )
    private static let dependency = Target.Dependency.byName(name: name)
}

// MARK: - Providers

enum Providers {
    private static let name = "Providers"
    static let library = Product.library(name: name, targets: [name])
    static let target = Target.target(
        name: name,
        dependencies: [
            CachingInterface.dependency,
            Packages.networkingDependency,
            Packages.modelDependency,
        ]
    )
    static let testTarget = Target.testTarget(
        name: name.tests,
        dependencies: [
            dependency,
            CachingInterface.dependency,
            Packages.networkingDependency,
            Packages.modelDependency,
        ]
    )
    private static let dependency = Target.Dependency.byName(name: name)
}

// MARK: - Dependencies

enum Packages {
    static let networking = Package.Dependency.package(path: "../Networking")
    static let networkingDependency = Target.Dependency.product(
        name: "NetworkingInterface",
        package: "Networking"
    )
    static let model = Package.Dependency.package(path: "../Model")
    static let modelDependency = Target.Dependency.product(
        name: "Model",
        package: "Model"
    )
}

extension String {
    var tests: String { self + "Tests" }
}

extension Product: @retroactive @unchecked Sendable {}
extension Target: @retroactive @unchecked Sendable {}
extension Target.Dependency: @retroactive @unchecked Sendable {}
extension Package.Dependency: @retroactive @unchecked Sendable {}

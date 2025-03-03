// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v18)],
    products: [
        NetworkingInterface.library,
        AppleNetworkingImplementation.library,
    ],
    targets: [
        NetworkingInterface.target,
        AppleNetworkingImplementation.target,
        AppleNetworkingImplementation.testTarget,
    ]
)

enum NetworkingInterface {
    private static let name = "NetworkingInterface"
    static let library = Product.library(name: name, targets: [name])
    static let target = Target.target(name: name)
    static let dependency = Target.Dependency.byName(name: name)
}

enum AppleNetworkingImplementation {
    private static let name = "AppleNetworkingImplementation"
    static let library = Product.library(name: name, targets: [name])
    static let target = Target.target(
        name: name,
        dependencies: [NetworkingInterface.dependency]
    )
    static let testTarget = Target.testTarget(
        name: name.tests,
        dependencies: [
            dependency,
            NetworkingInterface.dependency,
        ]
    )
    private static let dependency = Target.Dependency.byName(name: name)
}

extension String {
    var tests: String { self + "Tests" }
}

extension Product: @retroactive @unchecked Sendable {}
extension Target: @retroactive @unchecked Sendable {}
extension Target.Dependency: @retroactive @unchecked Sendable {}

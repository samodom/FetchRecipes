// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: Model.name,
    platforms: [.iOS(.v17)],
    products: [
        Model.library,
    ],
    targets: [
        Model.target,
        Model.testTarget,
    ]
)

enum Model {
    static let name = "Model"
    static let library = Product.library(name: name, targets: [name])
    static let target = Target.target(name: name)
    static let targetDependency = Target.Dependency.target(name: name)
    static let testTarget = Target.testTarget(
        name: name.tests,
        dependencies: [targetDependency],
        resources: [.process("Resources")]
    )
}

extension String {
    var tests: String { self + "Tests" }
}

extension Product: @retroactive @unchecked Sendable {}
extension Target: @retroactive @unchecked Sendable {}
extension Target.Dependency: @retroactive @unchecked Sendable {}

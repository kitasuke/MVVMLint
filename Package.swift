// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MVVMLint",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50100.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MVVMLint",
            dependencies: ["MVVMLintCore"]),
        .target(
            name: "MVVMLintCore",
            dependencies: ["SwiftSyntax"]),
        .testTarget(
            name: "MVVMLintTests",
            dependencies: ["MVVMLint"]),
        .testTarget(
            name: "MVVMLintCoreTests",
            dependencies: ["MVVMLintCore"]),
    ]
)

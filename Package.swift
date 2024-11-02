// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "extensions",
    defaultLocalization: "en",
    platforms: [.iOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Extensions",
            targets: ["Extensions"]
        ),
        .library(
            name: "ExtensionRx",
            targets: ["ExtensionRx"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", branch: "main"),
        .package(url: "https://github.com/RxSwiftCommunity/Action.git", branch: "master"),
        .package(url: "https://github.com/RxSwiftCommunity/RxSwiftExt.git", branch: "main"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.57.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.54.6")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Extensions",
            dependencies: []
        ),
        .target(
            name: "ExtensionRx",
            dependencies: ["RxSwift", "Action", "RxSwiftExt"]
        ),
        .target(
            name: "Shared",
            dependencies: []
        ),
//        .testTarget(
//            name: "coreTests",
//            dependencies: ["core"],
//            path: "Tests"
//        ),
    ]
)

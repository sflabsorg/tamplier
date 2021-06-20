// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tamplier",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .executable(name: "tamplier", targets: ["Tamplier"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "0.4.3")),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/jpsim/Yams", .upToNextMajor(from: "4.0.6")),
        .package(name: "Mustache", url: "https://github.com/groue/GRMustache.swift", .upToNextMajor(from: "4.0.1"))
    ],
    targets: [
        .target(
            name: "Tamplier",
            dependencies: [
                "Rainbow",
                "Yams",
                "Mustache",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/CLI",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ]
        )
    ]
)

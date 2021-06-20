// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "{{ name }}",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "{{ name }}",
            targets: ["{{ name }}"]
        ),
    ],
    dependencies: [
        .package(name: "Bootstrap", url: "https://github.com/sflabsorg/bootstrap-ios", .branch("master"))
    ],
    targets: [
        .target(
            name: "{{ name }}",
            dependencies: [
                .product(name: "BootstrapAPI", package: "Bootstrap")
            ],
            path: "Sources"
        )
    ]
)

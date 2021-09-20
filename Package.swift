// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Coordinator",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "Coordinator",
            targets: ["Coordinator"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Coordinator",
            dependencies: []
        ),
        .testTarget(
            name: "CoordinatorTests",
            dependencies: ["Coordinator"]
        ),
    ]
)

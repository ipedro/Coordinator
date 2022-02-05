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
        .library(
            name: "CoordinatorAPI",
            targets: ["CoordinatorAPI"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CoordinatorAPI",
            dependencies: []
        ),
        .target(
            name: "Coordinator",
            dependencies: ["CoordinatorAPI"]
        ),
        .testTarget(
            name: "CoordinatorTests",
            dependencies: ["CoordinatorAPI", "Coordinator"]
        ),
    ]
)

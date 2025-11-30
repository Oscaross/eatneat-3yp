// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "EatNeatMCP",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "EatNeatMCP",
            targets: ["EatNeatMCP"]
        )
    ],
    dependencies: [
        // ↓ Add this
        .package(url: "https://github.com/cocoanetics/SwiftMCP.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "EatNeatMCP",
            dependencies: [
                // ↓ And this
                .product(name: "SwiftMCP", package: "SwiftMCP")
            ],
            path: "Sources"
        )
    ]
)

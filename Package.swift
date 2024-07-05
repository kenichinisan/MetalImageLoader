// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MetalImageLoader",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MetalImageLoader",
            targets: ["MetalImageLoader"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MetalImageLoader",
            dependencies: [],
            resources: [
                .process("Shaders.metal")
            ]
        ),
        .testTarget(
            name: "MetalImageLoaderTests",
            dependencies: ["MetalImageLoader"]),
    ]
)

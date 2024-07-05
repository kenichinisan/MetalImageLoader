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
    targets: [
        .target(
            name: "MetalImageLoader"),
        .testTarget(
            name: "MetalImageLoaderTests",
            dependencies: ["MetalImageLoader"]),
    ]
)

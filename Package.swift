// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SettingsUI",
    platforms: [.iOS(.v18), .macOS(.v15), .visionOS(.v2), .tvOS(.v18)],
    products: [
        .library(
            name: "SettingsUI",
            targets: ["SettingsUI"]
        ),
    ],
    targets: [
        .target(
            name: "SettingsUI"
        ),
    ]
)

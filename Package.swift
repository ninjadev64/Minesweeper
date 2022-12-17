// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Minesweeper",
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .executableTarget(
            name: "Minesweeper",
            dependencies: ["Rainbow"]
        ),
    ]
)

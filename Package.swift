// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "SwiftLintPlugins",
    products: [
        .plugin(name: "SwiftLint", targets: ["SwiftLint"]),
    ],
    targets: [
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.47.1/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "82ef90b7d76b02e41edd73423687d9cedf0bb9849dcbedad8df3a461e5a7b555"
        ),
        .plugin(
            name: "SwiftLint",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]
        ),
        .plugin(
            name: "SwiftLintCommand",
            capability: .command(
                intent: .custom(verb: "lint", description: "Lint all targets."),
                permissions: []
            ),
            dependencies: ["SwiftLintBinary"]
        ),
    ]
)

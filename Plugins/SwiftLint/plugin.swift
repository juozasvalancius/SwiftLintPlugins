import Foundation
import PackagePlugin

@main
struct SwiftLint: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let target = target as? SourceModuleTarget else { return [] }

        // Create empty source file as output, as a workaround for rdar://92573384 (Source: https://developer.apple.com/videos/play/wwdc2022/102/)
        let outputPath = context.pluginWorkDirectory.appending("Generated.swift")
        try "".write(to: URL(fileURLWithPath: outputPath.string), atomically: false, encoding: .utf8)

        return [
            .buildCommand(
                displayName: "Linting \(target.name)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    "--quiet",
                    "--in-process-sourcekit", // alternative to the environment variable
                    "--path",
                    target.directory.string   // only lint the files in the target directory
                ],
                environment: [:],
                inputFiles: target.sourceFiles(withSuffix: ".swift").map(\.path),
                outputFiles: [outputPath]
            )
        ]
    }
}

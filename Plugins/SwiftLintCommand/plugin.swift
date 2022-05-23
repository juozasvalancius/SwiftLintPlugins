import PackagePlugin
import Foundation

@main
struct SwiftLintCommand: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let swiftlint = try context.tool(named: "swiftlint").path.string
        let swiftlintURL = URL(fileURLWithPath: swiftlint, isDirectory: false)

        setenv("IN_PROCESS_SOURCEKIT", "YES", 1)

        let allArguments = ["lint"] + arguments
        let process = try Process.run(swiftlintURL, arguments: allArguments)
        process.waitUntilExit()

        if process.terminationReason != .exit || process.terminationStatus != 0 {
            Diagnostics.error("SwiftLint errors detected.")
        }
    }
}

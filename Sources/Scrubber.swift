import Foundation
import ArgumentParser

@main
struct Scrubber : ParsableCommand {
    @Option(help: "Optionally specify the path to your workspace. Defaults to the current working directory.")
    var path: String = "./"

    public func run() throws {
        print("Scrub-a-dub-dub")

        let directoryURL = URL(fileURLWithPath: path)
        print(directoryURL)

        var directoryPaths: [String] = []

        if let enumerator = FileManager.default.enumerator(at: directoryURL, includingPropertiesForKeys: [.isDirectoryKey]) {
                for case let fileURL as URL in enumerator {
                    do {
                        let resourceValues = try fileURL.resourceValues(forKeys: [.isDirectoryKey])
                        if let isDirectory = resourceValues.isDirectory {
                            if isDirectory && fileURL.path.hasSuffix("node_modules") {
                                directoryPaths.append(fileURL.path)
                                enumerator.skipDescendants()
                                continue
                            }                        }
                    } catch {
                        print("Error reading resource values for \(fileURL): \(error)")
                    }
                }
            } else {
                print("Could not create enumerator for directory: \(directoryURL.path)")
            }

        for dirPath in directoryPaths {
            print(dirPath)
        }
    }
}

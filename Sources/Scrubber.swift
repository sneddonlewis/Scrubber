import ArgumentParser
import Foundation

func makeIsPurgeablePredicate(matches: [String]) -> (String) -> Bool {
    return { string in
        for match in matches {
            if string.hasSuffix(match) {
                return true
            }
        }
        return false
    }
}

func findPurgeablePaths(path: String, predicate: (String) -> Bool) -> [String] {
    let directoryURL = URL(fileURLWithPath: path)
    var directoryPaths: [String] = []

    if let enumerator = FileManager.default.enumerator(
        at: directoryURL, includingPropertiesForKeys: [.isDirectoryKey])
    {
        for case let fileURL as URL in enumerator {
            do {
                let resourceValues = try fileURL.resourceValues(forKeys: [.isDirectoryKey])
                if let isDirectory = resourceValues.isDirectory {
                    if isDirectory && predicate(fileURL.path) {
                        directoryPaths.append(fileURL.path)
                        enumerator.skipDescendants()
                        continue
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    } else {
        print("Error: Cannot traverse subdirectories of \(directoryURL.path)")
    }

    return directoryPaths
}

struct DirDeleteResult {
    public let path: String
    public let isSuccess: Bool
}

func deleteDirectory(path: String) -> DirDeleteResult {
    let directoryURL = URL(fileURLWithPath: path)

    do {
        try FileManager.default.removeItem(at: directoryURL)
        return DirDeleteResult(path: path, isSuccess: true)
    } catch {
        return DirDeleteResult(path: path, isSuccess: false)
    }
}

func deleteDirectories(paths: [String]) -> [DirDeleteResult] {
    var results: [DirDeleteResult] = []

    for path in paths {
        results.append(deleteDirectory(path: path))
    }

    return results
}

@main
struct Scrubber: ParsableCommand {
    @Option(
        help:
            "Optionally specify the path to your workspace. Defaults to the current working directory."
    )
    var path: String = "./"

    public func run() throws {
        print("Scrub-a-dub-dub")

        let dirNamesToPurge = [
            "node_modules"
        ]

        let isPurgeable = makeIsPurgeablePredicate(matches: dirNamesToPurge)

        let directoryPaths = findPurgeablePaths(path: path, predicate: isPurgeable)

        if directoryPaths.count == 0 {
            print("Found 0 directories to remove.")
            return
        }

        print("Attempting to remove \(directoryPaths.count) directories")

        let deleteResults = deleteDirectories(paths: directoryPaths)

        let failures = deleteResults.filter({ !$0.isSuccess })

        if failures.count != 0 {
            print("Sucessfully removed: \(deleteResults.count - failures.count) directories")
            for failure in failures {
                print("Failed to remove: \(failure.path)")
            }
            return
        }

        print("Sucessfully removed: \(deleteResults.count - failures.count) directories")
    }
}

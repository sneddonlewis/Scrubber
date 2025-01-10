import ArgumentParser

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

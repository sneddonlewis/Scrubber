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

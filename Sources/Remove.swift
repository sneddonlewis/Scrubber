import Foundation

func deleteDirectory(path: String) -> FileOpResult {
    let directoryURL = URL(fileURLWithPath: path)

    do {
        try FileManager.default.removeItem(at: directoryURL)
        return FileOpResult(path: path, isSuccess: true)
    } catch {
        return FileOpResult(path: path, isSuccess: false)
    }
}

func deleteDirectories(paths: [String]) -> [FileOpResult] {
    var results: [FileOpResult] = []

    for path in paths {
        results.append(deleteDirectory(path: path))
    }

    return results
}

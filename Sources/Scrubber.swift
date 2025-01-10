import ArgumentParser

@main
struct Scrubber : ParsableCommand {
    @Option(help: "Optionally specify the path to your workspace. Defaults to the current working directory.")
    var path: String = "./"

    public func run() throws {
        print("Scrub-a-dub-dub")
        print(path)
    }
}

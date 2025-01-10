import ArgumentParser

@main
struct Scrubber : ParsableCommand {
    @Option(help: "Specify the path to your workspace")
    public var path: String

    public func run() throws {
        print("Scrub-a-dub-dub")
        print(path)
    }
}

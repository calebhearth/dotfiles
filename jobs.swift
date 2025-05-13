// This is the source for bin/dict
// Compile with `swiftc -parse-as-library -o bin/dict`

import Foundation

@main
struct Job {
	static func main() {
		let args = CommandLine.arguments
			let states = args[1].split(separator: "^^^").map(String.init)
			let names = args[2].split(separator: "^^^").map(String.init)
			let dirs = args[3].split(separator: "^^^").map(String.init)

			let out: [String] = states.indices.compactMap { i in
				guard states[i].hasPrefix("suspended:"), dirs[i].hasPrefix(FileManager.default.currentDirectoryPath)
					else {
						return nil
					}
					return "\(names[i].split(separator: " ").first!):\(i)"
			}
		if !out.isEmpty {
			print("[\(out.joined(separator: " "))]")
		}
	}
}

// This is the source for bin/dict
// Compile with `swiftc -parse-as-library -o bin/dict`

import CoreServices.DictionaryServices
import Foundation

@main
struct Dict {
	static func define(_ word: String) -> String? {
		let nsstring = word as NSString
		let cfrange = CFRange(location: 0, length: nsstring.length)

		guard let definition = DCSCopyTextDefinition(nil, nsstring, cfrange) else {
			return nil
		}

		var def = String(definition.takeUnretainedValue())
			.replacing("▶", with: "\n")
			.replacing(" •", with: "\n  •")
			.replacing("ORIGIN", with: "\n\nORIGIN\n  ")
			.replacing("DERIVATIVES", with: "\n\nDERIVATIVES\n  ")
			.replacing("PHRASES", with: "\n\nPHRASES\n  ")

		let entryNumberRegex = try! Regex("[:space:]+(?<entryNumber>[0-9]+)[:space:]+")
		def.replace(entryNumberRegex, with: { "\n\n\($0.0). " })
		return def
	}

	static func main() {
		let args = CommandLine.arguments
		if args.count < 2 {
			print("Usage: dict <word>")
			return
		}

		let word = args[1]
		if let definition = define(word) {
			print(definition)
		} else {
			print("No definition found for \(word)")
		}
	}
}

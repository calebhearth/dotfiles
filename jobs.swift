// This is the source for bin/jobs
// Compile with `swiftc -parse-as-library -o bin/jobs jobs.swift`
//
// USAGE: jobs <states> <names> <dirs>
// ARGUMENTS:
//   <states>	zero or more states
//   <names>	zero or more names
//   <dirs>		zero or more dirs
//
//    Each array element should be followed by "^^^". The arrays must be the
//    same length. Each index of the various arrays refers to the job state,
//    name, and directory for a job to be displayed. The format of each is
//    documented in `zshmodules(1)`.
//
//    The intended usage is to call with the values of $jobstates, $jobtexts, and $jobdirs passed through `printf(1)` as
//    in the first example below.
//
// EXAMPLE:
//   jobs "$(printf '%s^^^' "${jobstates[@]}")" "$(printf '%s^^^' "${jobtexts[@]}")" "$(printf '%s^^^' "${jobdirs[@]}")"
//   jobs "suspended::1234=suspended^^^" "nvim jobs.swift^^^" "/Users/caleb/.dotfiles/^^^"

import Foundation

@main
struct Job {
	static func main() {
		let args = CommandLine.arguments
		let states = array(fromArg: args[1])
		let names = array(fromArg: args[2])
		let dirs = array(fromArg: args[3])

		var out: [String] = []
		for i in states.indices
		where states[i].hasPrefix("suspended:")
			&& dirs[i].hasPrefix(FileManager.default.currentDirectoryPath)
		{
			out.append("\(names[i].split(separator: " ").first!):\(i+1)")
		}
		if !out.isEmpty {
			print("[\(out.joined(separator: " "))]")
		}
	}

	private static func array(fromArg arg: String) -> [String] {
		let ary: [String] =
			arg
			.split(separator: "^^^", omittingEmptySubsequences: false)
			.map(String.init)
			.dropLast(1)
		print(ary.debugDescription)
		return ary
	}
}

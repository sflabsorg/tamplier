//
//  Created by Anton Spivak.
//  

import Foundation
import Rainbow

@discardableResult
func shell(_ command: String, verbose: Bool = true) -> Int32 {
    let task = Process()
    task.arguments = ["-c", command]
    task.launchPath = "/bin/bash"

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.launch()
    
    if verbose {
        pipe.fileHandleForReading.readabilityHandler = { pipe in
            guard let line = String(data: pipe.availableData, encoding: .utf8), !line.isEmpty
            else {
                return
            }
            print("shell:".onRed + " \(line)".magenta)
        }
    }
    
    task.waitUntilExit()
    return task.terminationStatus
}

//
//  Created by Anton Spivak.
//  

import Foundation

func xcconfig(set parameter: String, value: String, path: String) throws {
    try String(contentsOf: URL(fileURLWithPath: path))
        .components(separatedBy: "\n")
        .map({ (line: String) -> String in
            let settings = line.components(separatedBy: " = ")
            guard settings.count == 2 && settings[0] == parameter
            else {
                return line
            }
        
            return "\(settings[0]) = \(value)"
        })
        .joined(separator: "\n")
        .write(toFile: path, atomically: true, encoding: .utf8)
}

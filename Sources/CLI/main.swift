//
//  Created by Anton Spivak.
//  

import Foundation
import Rainbow
import ArgumentParser

struct Tamplier: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        abstract: "An utility to perfrom project generation from templates.",
        subcommands: [Generate.self, API.self],
        defaultSubcommand: Generate.self
    )
}

Tamplier.main()

//
//  DO NOT MODIFY THIS FILE
//
//  Created by tamplier generator.
//  

import Foundation
import BootstrapAPI

///
/// Default requests agent configuration
///
/// {{ title }}
/// {{ description }}
extension Agent {
    
    public static let `default`: Agent = {
        let configuration = Configuration(server: .default, headers: [:])
        let agent = Agent(configuration: configuration)
        return agent
    }()
}
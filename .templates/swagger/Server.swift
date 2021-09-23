//
//  DO NOT MODIFY THIS FILE
//
//  Created by tamplier generator.
//  

import Foundation
import BootstrapAPI

/**
 Default servers configuration
 
 {{ title }}
 {{ description }}
 */
extension Server {

    /// Server wich last in YML provided configuration
    /// {{ default }}
    public static let `default` = Server(rawValue: URL(string: "{{ default }}")!)!

{{# servers }}    
    /// {{ url }}
    public static let {{ name }} = Server(rawValue: URL(string: "{{ url }}")!)!
{{/ servers }}
}

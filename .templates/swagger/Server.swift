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

{{# servers }}    
    /// {{ url }}
    public static let {{ name }} = Server(rawValue: URL(string: "{{ url }}")!)!
{{/ servers }}
}

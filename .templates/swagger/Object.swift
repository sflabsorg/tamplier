//
//  DO NOT MODIFY THIS FILE
//
//  Created by tamplier generator.
//  

import Foundation
import BootstrapAPI

/**
 Default servers configuration
 
 {{ name }}
 {{ description }}
 */
extension API {
    {{# enums }}
    public enum {{ name }}: {{ type }}, Codable {
        {{# cases }}
        /// {{ description }}
        case {{ name }} {{/ cases }}
    }
    {{/ enums }}
    public struct {{ name }}: Model {
        {{# properties }}    
        /// {{ description }}
        public var {{ name }}: {{ type }}
        {{/ properties }}
        public init({{ init }}) {
            {{# properties }}
            self.{{name}} = {{ name }}{{/ properties }}
        }
    }
}

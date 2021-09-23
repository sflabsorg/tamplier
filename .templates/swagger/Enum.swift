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
    
    public enum {{ name }}: {{ type }}, Model {
        {{# cases }}
        /// {{ description }}
        case {{ name }} {{/ cases }}
    }
}

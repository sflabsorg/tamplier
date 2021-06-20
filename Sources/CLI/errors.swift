//
//  Created by Anton Spivak.
//  

import Foundation
import Rainbow

enum RuntimeError: Error, CustomStringConvertible {
    
    case message(String)
    
    var description: String {
        switch self {
        case .message(let message): return message.onRed
        }
    }
}

//
//  DO NOT MODIFY THIS FILE
//
//  Created by tamplier generator.
//  

import Foundation
import BootstrapAPI

{{# queries }}
/// {{ path }}
/// {{ description }}
extension API.{{ uppercased_type }} {

    public struct {{ name }}: Query {
        
        public typealias R = {{ response_type }}
        {{# parameters }}
        public var {{ name }}: {{ type }}{{/ parameters }}
        
        public var headers: [String : String] = [ "Content-Type" : "{{ content_type }}" ]
        public var type: QueryType { .{{ lowercased_type }} }
        public var path: String { "{{ path }}\(QueryParameters([{{# gquery }}("{{ name }}", {{ name }}){{/ gquery }}]))" }
        
        public init({{ init }}) {
            {{# parameters }}
            self.{{name}} = {{name}}{{/ parameters }}
        }
    }
}
{{/ queries }}

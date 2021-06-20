//
//  Created by Anton Spivak.
//  

import Foundation
import Rainbow

extension String {
    
    func standardizingPath() -> String {
        return ((self as NSString).standardizingPath as NSString).expandingTildeInPath
    }
    
    func lowercaseFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    func uppercaseFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    func contents() throws -> String {
        let fileManager = FileManager.default
        
        let url: URL
        if fileManager.fileExists(atPath: self) {
            url = URL(fileURLWithPath: self)
        } else {
            guard let _url = URL(string: self)
            else {
                throw RuntimeError.message("Can't create URL with given pah \(self).")
            }
            url = _url
        }
        
        var contents: String
        if url.isFileURL {
            contents = try String(contentsOf: url)
        } else {
            let error = RuntimeError.message("Can't donwload file for given url \(url) or file at url is empty.")
            var request: URLRequest
            
            if var components = URLComponents(url: url, resolvingAgainstBaseURL: false), let user = components.user, let password = components.password {
                guard let data = "\(user):\(password)".data(using: .utf8)
                else {
                    throw error
                }
                
                let base64 = data.base64EncodedString()
                
                components.user = nil
                components.password = nil
                
                guard let url = components.url
                else {
                    throw error
                }
                
                request = URLRequest(url: url)
                request.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
            } else {
                request = URLRequest(url: url)
            }
            
            let session = URLSession.shared
            let sem = DispatchSemaphore(value: 0)
            var data: Data?
            
            let task = session.dataTask(with: request, completionHandler: { (_data, response, error) in
                data = _data
                sem.signal()
            })
            task.resume()
            let _ = sem.wait(wallTimeout: .distantFuture)
        
            guard let data = data,
                  let string = String(data: data, encoding: .utf8)
            else {
                throw error
            }
            
            contents = string
        }
        
        return contents
    }
}

extension FileManager {
    
    func isDirectoryEmpty(at path: String) throws -> Bool {
        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: path, isDirectory: nil) {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        
        let allowed = [".git", ".DS_Store"]
        let contents = try fileManager.contentsOfDirectory(atPath: path).filter({ !allowed.contains($0) })
        guard contents.count == 0
        else {
            return false
        }
        
        return true
    }
}

extension Array {
    
    public func forEachIndex(_ body: (Element, Int) throws -> Void) rethrows {
        var index = 0
        try forEach({ element in
            try body(element, index)
            index += 1
        })
    }
    
    public func mapIndex<T>(_ transfrom: (Element, Int) throws -> T) rethrows -> [T] {
        var index = 0
        return try map({ element in
            let value = try transfrom(element, index)
            index += 1
            return value
        })
    }
}

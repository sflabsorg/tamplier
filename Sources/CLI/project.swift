//
//  Created by Anton Spivak.
//  

import Foundation
import Rainbow
import ArgumentParser

struct Generate: ParsableCommand {
    
    enum Template: String, EnumerableFlag {
        
        case auth = "Authentication"
        
        static func name(for value: Self) -> NameSpecification {
            switch value {
            case .auth: return [.customLong("auth")]
            }
        }
    }
    
    static var configuration = CommandConfiguration(
        commandName: "generate",
        abstract: "Generates Xcode project for given template type."
    )
    
    @Flag(help: "Type of template that will being used for generation.")
    var template: Template
    
    @Option(name: .customLong("output"), help: "Output directory of generated project")
    var output: String
    
    @Option(name: .customLong("name"), help: "Product name")
    var name: String
    
    @Option(name: .customLong("identifier"), help: "Product bundle identifier")
    var identifier: String
    
    mutating func run() throws {
        let fileManager = FileManager.default
        let cwd = fileManager.currentDirectoryPath
        
        let outputPath = (("\(output)/" as NSString).standardizingPath as NSString).expandingTildeInPath
        
        if !fileManager.fileExists(atPath: outputPath, isDirectory: nil) {
            try fileManager.createDirectory(atPath: outputPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        let allowed = [".git", ".DS_Store"]
        let contents = try fileManager.contentsOfDirectory(atPath: outputPath).filter({ !allowed.contains($0) })
        guard contents.count == 0
        else {
            throw RuntimeError.message("Directory \(outputPath) not empty.")
        }
        
        let gitRepoPath = "git@github.com:sflabsorg/tamplier.git"
        let gitClonePath = "\(cwd)/.tamplier/"
        
        if fileManager.fileExists(atPath: gitClonePath, isDirectory: nil) {
            try fileManager.removeItem(atPath: gitClonePath)
        }
        
        guard shell("git clone \(gitRepoPath) \(gitClonePath)") == 0
        else {
            throw RuntimeError.message("Can't clone \(gitRepoPath), check access rights.")
        }
        
        let projectName = name.uppercaseFirstLetter()
        let templatesPath = "\(gitClonePath)/.templates"
        
        let projectTemplatePath = "\(templatesPath)/\(template.rawValue)"
        let workspaceTemplatePath = "\(templatesPath)/common.xcworkspace"
        let gitignoreTemplatePath = "\(templatesPath)/gitignore"
        
        let projectResultPath = "\(outputPath)/Application"
        let xcodeprojResultPath = "\(projectResultPath)/Application.xcodeproj"
        let xcworkspaceResultPath = "\(outputPath)/\(projectName).xcworkspace"
        let gitignoreResultPath = "\(outputPath)/.gitignore"
        
        // Copying
        
        try fileManager.copyItem(atPath: projectTemplatePath, toPath: projectResultPath)
        try fileManager.moveItem(atPath: "\(projectResultPath)/\(template.rawValue).xcodeproj", toPath: xcodeprojResultPath)
        
        try fileManager.copyItem(atPath: workspaceTemplatePath, toPath: xcworkspaceResultPath)
        try fileManager.copyItem(atPath: gitignoreTemplatePath, toPath: gitignoreResultPath)
        
        // Renaming
        
        let xcschemeTemplatePath = "\(xcodeprojResultPath)/xcshareddata/xcschemes/\(template.rawValue).xcscheme"
        let xcschemeResultPath = "\(xcodeprojResultPath)/xcshareddata/xcschemes/Application.xcscheme"
        
        try fileManager.moveItem(atPath: xcschemeTemplatePath, toPath: xcschemeResultPath)
        
        // Editing
        
        let pbxprojPath = "\(xcodeprojResultPath)/project.pbxproj"
        var pbxprojPathContents = try String(contentsOf: URL(fileURLWithPath: pbxprojPath))
        pbxprojPathContents = pbxprojPathContents.replacingOccurrences(of: "PBXProject \"\(template.rawValue)\"", with: "PBXProject \"\(projectName)\"")
        try pbxprojPathContents.write(toFile: pbxprojPath, atomically: true, encoding: .utf8)
        
        let xcworkspacedataPath = "\(xcworkspaceResultPath)/contents.xcworkspacedata"
        var xcworkspacedataPathContents = try String(contentsOf: URL(fileURLWithPath: xcworkspacedataPath))
        xcworkspacedataPathContents = xcworkspacedataPathContents.replacingOccurrences(of: "__REPLACE_ME__", with: "Application/Application.xcodeproj")
        try xcworkspacedataPathContents.write(toFile: xcworkspacedataPath, atomically: true, encoding: .utf8)
        
        let xcschemePath = xcschemeResultPath
        var xcschemePathContents = try String(contentsOf: URL(fileURLWithPath: xcschemePath))
        xcschemePathContents = xcschemePathContents.replacingOccurrences(of: "container:\(template.rawValue).xcodeproj", with: "container:Application.xcodeproj")
        xcschemePathContents = xcschemePathContents.replacingOccurrences(of: "BuildableName = \"Application.app\"", with: "BuildableName = \"\(projectName).app\"")
        try xcschemePathContents.write(toFile: xcschemePath, atomically: true, encoding: .utf8)
        
        // Configuration
        
        let productName = projectName.uppercaseFirstLetter()
        let productBundleIdentifier = identifier
        
        let xcconfigDebugPath = "\(projectResultPath)/Application/Supporting/Configuration/Debug.xcconfig"
        try xcconfig(set: "PRODUCT_NAME", value: productName, path: xcconfigDebugPath)
        try xcconfig(set: "PRODUCT_BUNDLE_IDENTIFIER", value: productBundleIdentifier, path: xcconfigDebugPath)
        
        let xcconfigRelease = "\(projectResultPath)/Application/Supporting/Configuration/Release.xcconfig"
        try xcconfig(set: "PRODUCT_NAME", value: productName, path: xcconfigRelease)
        try xcconfig(set: "PRODUCT_BUNDLE_IDENTIFIER", value: productBundleIdentifier, path: xcconfigRelease)
        
        print("Cool! Did create project at path: ".white + outputPath.cyan + "\n")
        print("Next steps:".cyan)
        print("- use \(xcworkspaceResultPath) for project editing.".white)
        print("- choose signing certificate if you want build to device".white)
        
        try fileManager.removeItem(atPath: gitClonePath)
        shell("open \(projectResultPath)")
    }
}

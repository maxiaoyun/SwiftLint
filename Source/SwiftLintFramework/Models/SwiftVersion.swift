//
//  SwiftVersion.swift
//  SwiftLint
//
//  Created by Marcelo Fabri on 12/29/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import SourceKittenFramework

enum SwiftVersion {
    case two
    case three

    static let current: SwiftVersion = {
        let isSandboxed = ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
        if isSandboxed {
            // Fall back on Swift 3 if app is Sandboxed and SourceKit requests will fail
            return .three
        }
        let file = File(contents: "#sourceLocation()")
        let kinds = file.syntaxMap.tokens.flatMap { SyntaxKind(rawValue: $0.type) }
        if kinds == [.identifier] {
            return .two
        } else if kinds == [.keyword] {
            return .three
        }

        fatalError("Unexpected Swift version")
    }()
}

//
//  Common.swift
//  MVVMLintCoreTests
//
//  Created by Yusuke Kita on 10/16/19.
//

import Foundation
import SwiftSyntax
@testable import MVVMLintCore

func createSourceFile(from input: String, suffix: String = "") -> String {
    var filename = UUID().uuidString
    filename.append(suffix)
    let url = URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent(filename)
        .appendingPathExtension("swift")
    try! input.write(to: url, atomically: true, encoding: .utf8)
    
    return url.path
}

func makeSyntax(from input: String) throws -> SourceFileSyntax {
    let path = createSourceFile(from: input, suffix: "ViewModel")
    let parser = Parser(file: File(path: path))
    return try parser.parseSyntax()
}

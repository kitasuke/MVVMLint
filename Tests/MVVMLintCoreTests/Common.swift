//
//  Common.swift
//  MVVMLintCoreTests
//
//  Created by Yusuke Kita on 10/16/19.
//

import Foundation
import SwiftSyntax
@testable import MVVMLintCore

func createSourceFile(from input: String, suffix: String = "", filename: String = "") -> String {
    var filename = filename.isEmpty ? UUID().uuidString : filename
    filename.append(suffix)
    let url = URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent(filename)
        .appendingPathExtension("swift")
    try! input.write(to: url, atomically: true, encoding: .utf8)
    
    return url.path
}

//
//  Common.swift
//  MVVMLintCoreTests
//
//  Created by Yusuke Kita on 10/16/19.
//

import Foundation
import SwiftSyntax
@testable import MVVMLintCore

func createSourceFile(from input: String, suffix: String = "", foldername: String = "", filename: String = "") -> String {
    let foldername = foldername.isEmpty ? UUID().uuidString : foldername
    let filename = (filename.isEmpty ? UUID().uuidString : filename).appending(suffix)
    let url = URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent(foldername, isDirectory: true)
        .appendingPathComponent(filename)
        .appendingPathExtension("swift")
    try! input.write(to: url, atomically: true, encoding: .utf8)
    
    return url.path
}

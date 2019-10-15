//
//  FileParser.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/08.
//

import Foundation
import SwiftSyntax

public class FileParser {

    public let pathURL: URL

    public init(path: String) {
        self.pathURL = URL(fileURLWithPath: path)
    }

    public func parse() throws -> SourceFileSyntax {
        return try SyntaxParser.parse(pathURL)
    }
}


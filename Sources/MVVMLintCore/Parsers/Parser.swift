//
//  FileParser.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/08.
//

import Foundation
import SwiftSyntax

public class Parser {

    public init() {}

    public func parse<File: FileType>(fileType: File) throws -> File.VisitorType.Syntax {

        let syntax = try parseSyntax(path: fileType.path)
        var visitor = fileType.visitor
        syntax.walk(&visitor)
        return visitor.parsedSyntax
    }

    func parseSyntax(path: String) throws -> SourceFileSyntax {
        let pathURL = URL(fileURLWithPath: path)
        return try SyntaxParser.parse(pathURL)
    }
}


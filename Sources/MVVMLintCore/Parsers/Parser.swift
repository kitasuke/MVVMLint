//
//  FileParser.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/08.
//

import Foundation
import SwiftSyntax

public class Parser {

    public let file: File
    public let pathURL: URL

    public init(file: File) {
        self.file = file
        self.pathURL = URL(fileURLWithPath: file.path)
    }

    public func parse() throws -> ParsedSyntax {

        let syntax = try parseSyntax()

        switch file.kind {
        case .viewModel:
            var visitor = ViewModelVisitor()
            syntax.walk(&visitor)
            return visitor.parsedSyntax
        case .viewController:
            var visitor = ViewControllerVisitor()
            syntax.walk(&visitor)
            return visitor.parsedSyntax
        default:
            fatalError()
        }
    }

    func parseSyntax() throws -> SourceFileSyntax {
        return try SyntaxParser.parse(pathURL)
    }
}


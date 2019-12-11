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

    public func parseViewModel() throws -> ParsedViewModel {
        guard case .viewModel = file.kind else {
            fatalError()
        }

        let syntax = try parseSyntax()
        var visitor = ViewModelVisitor()
        syntax.walk(&visitor)
        return visitor.parsedViewModel
    }

    public func parseViewController() throws -> ParsedViewController {
        guard case .viewController = file.kind else {
            fatalError()
        }

        let syntax = try parseSyntax()
        var visitor = ViewControllerVisitor()
        syntax.walk(&visitor)
        return visitor.parsedViewController
    }

    func parseSyntax() throws -> SourceFileSyntax {
        return try SyntaxParser.parse(pathURL)
    }
}


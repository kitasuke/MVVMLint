//
//  ParsedViewModel.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 10/15/19.
//

import Foundation
import SwiftSyntax

public struct ParsedViewModel: ParsedSyntax {
    public var inputEnumCaseElements: [EnumCaseElementSyntax] = []
    public var outputEnumCaseElements: [EnumCaseElementSyntax] = []
    public var inputFuncDecls: [FunctionDeclSyntax] = []
    public var outputDecls: [DeclSyntax] = []

    public lazy var inputIdentifiers: [TokenSyntax] = {
        if inputEnumCaseElements.isEmpty {
            return inputFuncDecls
                .map { $0.identifier }
        } else {
            return inputEnumCaseElements
                .map { $0.identifier }
        }
    }()
    public lazy var outputIdentifiers: [TokenSyntax] = {
        if outputEnumCaseElements.isEmpty {
            return outputDecls
                .compactMap { decl in
                    switch decl {
                    case let variable as VariableDeclSyntax:
                        return variable.bindings
                            .compactMap { $0.pattern as? IdentifierPatternSyntax }
                            .first
                            .map { $0.identifier }
                    case let functionDecl as FunctionDeclSyntax:
                        return functionDecl.identifier
                    default:
                        return nil
                    }
            }
        } else {
            return outputEnumCaseElements
                .map { $0.identifier }
        }
    }()
    
    public init() {}
}

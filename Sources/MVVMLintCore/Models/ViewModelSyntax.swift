//
//  ViewModelSyntax.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 10/15/19.
//

import Foundation
import SwiftSyntax

public struct ViewModelSyntax {
    public var inputsFuncDecls: [FunctionDeclSyntax] = []
    public var outputsDecls: [DeclSyntax] = []
    public var inputsEnumCaseElements: [EnumCaseElementSyntax] = []
    public var outputsEnumCaseElements: [EnumCaseElementSyntax] = []
    
    public lazy var inputsDeclIdentifiers: [String] = {
        return inputsFuncDecls
            .map { $0.identifier.text }
    }()
    public lazy var outputDeclIdentifiers: [String] = {
        return outputsDecls
            .compactMap { decl in
                switch decl {
                case let variable as VariableDeclSyntax:
                    return variable.bindings
                        .compactMap { $0.pattern as? IdentifierPatternSyntax }
                        .first
                        .map { $0.identifier.text }
                case let functionDecl as FunctionDeclSyntax:
                    return functionDecl.identifier.text
                default:
                    return nil
                }
        }
    }()
    public lazy var inputsCaseIdentifiers: [String] = {
        return inputsEnumCaseElements
            .map { $0.identifier.text }
    }()
    public lazy var outputsCaseIdentifiers: [String] = {
        return outputsEnumCaseElements
            .map { $0.identifier.text }
    }()
    
    public init() {}
}

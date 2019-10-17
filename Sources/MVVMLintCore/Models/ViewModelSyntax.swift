//
//  ViewModelSyntax.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 10/15/19.
//

import Foundation
import SwiftSyntax

public struct ViewModelSyntax {
    public var inputsEnumCaseElements: [EnumCaseElementSyntax] = []
    public var outputsEnumCaseElements: [EnumCaseElementSyntax] = []
    public var inputsFuncDecls: [FunctionDeclSyntax] = []
    public var outputsDecls: [DeclSyntax] = []

    public lazy var inputsIdentifiers: [String] = {
        if inputsEnumCaseElements.isEmpty {
            return inputsFuncDecls
                .map { $0.identifier.text }
        } else {
            return inputsEnumCaseElements
                .map { $0.identifier.text }
        }
    }()
    public lazy var outputsIdentifiers: [String] = {
        if outputsEnumCaseElements.isEmpty {
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
        } else {
            return outputsEnumCaseElements
                .map { $0.identifier.text }
        }
    }()
    
    public init() {}
}

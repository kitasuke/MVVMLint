//
//  ViewModelVisitor.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/10.
//

import Foundation
import SwiftSyntax

public struct ViewModelVisitor: SyntaxVisitor {
    
    public var parsedViewModel = ParsedViewModel()

    public init() {}

    // visit visits class decl for `class Foo: FooViewModelType {}`
    public mutating func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        guard node.inheritanceClause?.inheritedTypeCollection.containsViewModelType() == true else {
            return .skipChildren
        }

        return .visitChildren
    }
    
    // visitPost post-visits enum decl for case identifiers in `enum Inputs/Outputs { case foo }`
    public mutating func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        let enumIdentifier = node.identifier.text
        let caseElements = node.members.members
            .compactMap { $0.decl as? EnumCaseDeclSyntax }
            .flatMap { $0.elements.map { $0 } }
        
        if enumIdentifier.hasSuffix("Inputs") {
            parsedViewModel.inputsEnumCaseElements = caseElements
        } else if enumIdentifier.hasSuffix("Outputs") {
            parsedViewModel.outputsEnumCaseElements = caseElements
        }
        return .skipChildren
    }

    // visitPost post-visits protocol delc for identifiers in `protocol FooViewModelInputs {}` and `protocol FooViewModelOutputs {}`
    public mutating func visitPost(_ node: ProtocolDeclSyntax) {
        let name = node.identifier.text
        if name.hasSuffix(ProtocolIdentifier.inputs.name) {
            let inputsFuncDeclSyntaxes = node.members.members
                .compactMap { $0.decl as? FunctionDeclSyntax }
            parsedViewModel.inputsFuncDecls = inputsFuncDeclSyntaxes
        } else if name.hasSuffix(ProtocolIdentifier.outputs.name) {
            let outputsIdentifierSyntaxes = node.members.members.map { $0.decl }
            parsedViewModel.outputsDecls = outputsIdentifierSyntaxes
        }
    }
}

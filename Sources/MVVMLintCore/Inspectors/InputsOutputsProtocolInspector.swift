//
//  InputsOutputsProtocolInspector.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/10.
//

import Foundation
import SwiftSyntax

public struct InputsOutputsProtocolInspector: SyntaxVisitor {

    public var inputsFunctionIdentifiers: [String] = []
    public var outputsVariableIdentifiers: [String] = []

    public init() {}

    // visit visits class decl for `class Foo: FooViewModelInputs, FooViewModelOutputs, FooViewModelType {}`
    public mutating func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        guard node.inheritanceClause?.inheritedTypeCollection.containsViewModelInputsOutputsType() == true else {
            return .skipChildren
        }

        return .visitChildren
    }

    // visitPost post-visits protocol delc for identifiers in `protocol FooViewModelInputs {}` and `protocol FooViewModelOutputs {}`
    public mutating func visitPost(_ node: ProtocolDeclSyntax) {
        let name = node.identifier.text
        if name.hasSuffix(ProtocolIdentifier.inputs.name) {
            self.inputsFunctionIdentifiers = node.members.members
                .compactMap { ($0.decl as? FunctionDeclSyntax)?.identifier.text }
        } else if name.hasSuffix(ProtocolIdentifier.outputs.name) {
            self.outputsVariableIdentifiers = node.members.members
                .compactMap { $0.decl as? VariableDeclSyntax }
                .flatMap { $0.bindings }
                .compactMap { ($0.pattern as? IdentifierPatternSyntax)?.identifier.text }
        }
    }
}

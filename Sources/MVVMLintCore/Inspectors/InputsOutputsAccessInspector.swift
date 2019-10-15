//
//  InputsOutputsAccessInspector.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/11.
//

import Foundation
import SwiftSyntax

public struct InputsOutputsAccessInspector: SyntaxVisitor {

    public var inputsMemberAccesses: [String] = []
    public var outputsMemberAccesses: [String] = []

    public init() {}

    // visit visits class decl for `class Foo: ViewModelType {}`
    public mutating func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        guard node.inheritanceClause?.inheritedTypeCollection.containsViewModelType() == true else {
            return .skipChildren
        }

        return .visitChildren
    }

    // visitPost post-visits member access expression for `viewModel.inputs.foo()` or `viewModel.outputs.bar = ...`
    public mutating func visitPost(_ node: MemberAccessExprSyntax) {
        guard let baseExpr = node.base as? MemberAccessExprSyntax else {
            return
        }

        let memberAccessName = baseExpr.name.text
        switch memberAccessName {
        case "inputs":
            self.inputsMemberAccesses.append(memberAccessName)
        case "outputs":
            self.outputsMemberAccesses.append(memberAccessName)
        default:
            return
        }
    }
}

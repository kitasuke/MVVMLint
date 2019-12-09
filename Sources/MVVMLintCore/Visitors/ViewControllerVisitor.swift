//
//  ViewControllerVisitor.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/11.
//

import Foundation
import SwiftSyntax

public struct ViewControllerVisitor: SyntaxVisitor {

    public var viewControllerSyntax = ViewControllerSyntax()

    public init() {}
    
    // visit visits function call expr for `viewModel.apply(_:)` and `viewModel.outputsObservable.subscribe {}`
    public mutating func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if node.hasApplyMemberAccess() {
            viewControllerSyntax.inputsFunctionCalls.append(node)
            return .skipChildren
        } else if node.hasSubscribeMemberAccess(),
            let closureExpr = node.trailingClosure?.statements {
            let switchCases = closureExpr
                .compactMap { $0.item as? SwitchStmtSyntax }
                .flatMap { $0.cases.compactMap { $0 as? SwitchCaseSyntax } }
            viewControllerSyntax.outputsSwitchCases.append(contentsOf: switchCases)
            return .skipChildren
        }
        
        return .visitChildren
    }

    // visit visits member access expression for `viewModel.inputs.foo()` and `viewModel.outputs.bar = ...`
    public mutating func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        guard let memberAccessExpr = node.base as? MemberAccessExprSyntax,
            let identifierExpr = memberAccessExpr.base as? IdentifierExprSyntax,
            identifierExpr.isViewModel() else {
            return .skipChildren
        }

        let memberAccessName = memberAccessExpr.name.text
        if memberAccessName == "inputs" {
            viewControllerSyntax.inputsMemberAccesses.append(node)
        } else if memberAccessName == "outputs" {
            viewControllerSyntax.outputsMemberAccesses.append(node)
        }
        return .skipChildren
    }
}

//
//  ViewControllerVisitor.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/11.
//

import Foundation
import SwiftSyntax

public struct ViewControllerVisitor: MVVMVisitor {

    public var parsedSyntax = ParsedViewController()

    public init() {}
    
    // visit visits function call expr for `viewModel.apply(_:)` and `viewModel.outputsObservable.subscribe {}`
    public mutating func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if node.hasApplyMemberAccess() {
            parsedSyntax.inputFunctionCalls.append(node)
            return .skipChildren
        } else if node.hasSubscribeMemberAccess(),
            let closureExpr = node.trailingClosure?.statements {
            let switchCases = closureExpr
                .compactMap { $0.item as? SwitchStmtSyntax }
                .flatMap { $0.cases.compactMap { $0 as? SwitchCaseSyntax } }
            parsedSyntax.outputSwitchCases.append(contentsOf: switchCases)

            // to visit input function call in closure body, return .visitChildren
            return .visitChildren
        }
        
        return .visitChildren
    }

    // visit visits member access expression for `viewModel.inputs.foo()` and `viewModel.outputs.bar = ...`
    public mutating func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        guard let memberAccessExpr = node.base as? MemberAccessExprSyntax,
            memberAccessExpr.hasViewModel() else {
            return .skipChildren
        }

        let memberAccessName = memberAccessExpr.name.text
        if memberAccessName == "inputs" {
            parsedSyntax.inputMemberAccesses.append(node)
        } else if memberAccessName == "outputs" {
            parsedSyntax.outputMemberAccesses.append(node)
        }
        return .skipChildren
    }
}

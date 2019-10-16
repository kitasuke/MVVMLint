//
//  ExprSyntax+InputsOutputs.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 10/16/19.
//

import Foundation
import SwiftSyntax

extension IdentifierExprSyntax {
    func isViewModel() -> Bool {
        return identifier.text == "viewModel"
    }
}

extension FunctionCallExprSyntax {
    func hasApplyMemberAccess() -> Bool {
        guard let memberAccessExpr = calledExpression as? MemberAccessExprSyntax,
            let identifierExpr = memberAccessExpr.base as? IdentifierExprSyntax,
            identifierExpr.isViewModel(),
            memberAccessExpr.name.text == "apply" else {
            return false
        }
        return true
    }
    
    func hasSubscribeMemberAccess() -> Bool {
        guard let baseExpr = calledExpression as? MemberAccessExprSyntax,
            let memberAccessExpr = baseExpr.base as? MemberAccessExprSyntax,
            let identifierExpr = memberAccessExpr.base as? IdentifierExprSyntax,
            identifierExpr.isViewModel(),
            memberAccessExpr.name.text == "outputsObservable",
            baseExpr.name.text == "subscribe" else {
                return false
        }
        return true
    }
}

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

extension MemberAccessExprSyntax {
    func hasViewModel() -> Bool {
        guard let base = base else {
            return false
        }

        switch base {
        case let identifierExpr as IdentifierExprSyntax:
            // viewModel.apply()
            return identifierExpr.isViewModel()
        case let memberAccessExpr as MemberAccessExprSyntax:
            // self?.viewModel.apply()
            return memberAccessExpr.name.text == "viewModel"
        default:
            return false
        }
    }

    func hasApply() -> Bool {
        return name.text == "apply"
    }
}

extension FunctionCallExprSyntax {
    func hasApplyMemberAccess() -> Bool {
        // xxx.xxx.apply()
        guard let memberAccessExpr = calledExpression as? MemberAccessExprSyntax,
            memberAccessExpr.hasApply(),
            memberAccessExpr.hasViewModel() else {
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

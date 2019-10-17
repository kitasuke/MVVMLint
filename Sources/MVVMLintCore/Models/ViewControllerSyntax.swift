//
//  ViewControllerSyntax.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 10/15/19.
//

import Foundation
import SwiftSyntax

public struct ViewControllerSyntax {
    public var inputsFunctionCalls: [FunctionCallExprSyntax] = []
    public var outputsSwitchCases: [SwitchCaseSyntax] = []
    public var inputsMemberAccesses: [MemberAccessExprSyntax] = []
    public var outputsMemberAccesses: [MemberAccessExprSyntax] = []
    
    public lazy var inputsFunctionArgumentIdentidiers: [String] = {
        return inputsFunctionCalls
            .flatMap { $0.argumentList.map { $0.expression } }
            .compactMap { expr in
                if let memberAccessExpr = expr as? MemberAccessExprSyntax {
                    return memberAccessExpr.name.text
                } else if let functionCallExpr = expr as? FunctionCallExprSyntax,
                    let memberAccessExpr = functionCallExpr.calledExpression as? MemberAccessExprSyntax {
                    return memberAccessExpr.name.text
                }
                return nil
        }
    }()
    
    public lazy var outputsCaseLabelIdentifiers: [String] = {
        return outputsSwitchCases
            .compactMap { $0.label as? SwitchCaseLabelSyntax }
            .flatMap { $0.caseItems
                .compactMap { $0.pattern as? ExpressionPatternSyntax }
                .compactMap { pattern in
                    if let identifierExpr = pattern.expression as? IdentifierExprSyntax {
                        return identifierExpr.identifier.text
                    } else if let functionCallExpr = pattern.expression as? FunctionCallExprSyntax,
                        let identifierExpr = functionCallExpr.calledExpression as? IdentifierExprSyntax {
                        return identifierExpr.identifier.text
                    }
                    return nil
                }
        }
    }()
    
    public lazy var inputsMemberAccessIdentifiers: [String] = {
        return inputsMemberAccesses
            .map { $0.name.text }
    }()
    
    public lazy var outputsMemberAccessIdentifiers: [String] = {
        return outputsMemberAccesses
            .map { $0.name.text }
    }()
    
    public init() {}
}

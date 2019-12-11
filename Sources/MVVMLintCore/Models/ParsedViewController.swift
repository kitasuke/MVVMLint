//
//  ParsedViewController.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 10/15/19.
//

import Foundation
import SwiftSyntax

public protocol ParsedSyntax {}

public struct ParsedViewController: ParsedSyntax {
    public var inputFunctionCalls: [FunctionCallExprSyntax] = []
    public var outputSwitchCases: [SwitchCaseSyntax] = []
    public var inputMemberAccesses: [MemberAccessExprSyntax] = []
    public var outputMemberAccesses: [MemberAccessExprSyntax] = []
    
    public lazy var inputIdentifiers: [TokenSyntax] = {
        if inputFunctionCalls.isEmpty {
            return inputMemberAccesses
                .map { $0.name }
        } else {
            return inputFunctionCalls
                .flatMap { $0.argumentList.map { $0.expression } }
                .compactMap { expr in
                    if let memberAccessExpr = expr as? MemberAccessExprSyntax {
                        return memberAccessExpr.name
                    } else if let functionCallExpr = expr as? FunctionCallExprSyntax,
                        let memberAccessExpr = functionCallExpr.calledExpression as? MemberAccessExprSyntax {
                        return memberAccessExpr.name
                    }
                    return nil
            }
        }
    }()
    
    public lazy var outputIdentifiers: [TokenSyntax] = {
        if outputSwitchCases.isEmpty {
            return outputMemberAccesses
                .map { $0.name }
        } else {
            return outputSwitchCases
                .compactMap { $0.label as? SwitchCaseLabelSyntax }
                .flatMap { $0.caseItems
                    .compactMap { $0.pattern as? ExpressionPatternSyntax }
                    .compactMap { pattern in
                        if let identifierExpr = pattern.expression as? IdentifierExprSyntax {
                            return identifierExpr.identifier
                        } else if let functionCallExpr = pattern.expression as? FunctionCallExprSyntax,
                            let identifierExpr = functionCallExpr.calledExpression as? IdentifierExprSyntax {
                            return identifierExpr.identifier
                        }
                        return nil
                    }
            }
        }
    }()
    
    public init() {}
}

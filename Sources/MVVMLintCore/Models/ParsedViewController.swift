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
    
    public lazy var inputIdentifiers: [String] = {
        if inputFunctionCalls.isEmpty {
            return inputMemberAccesses
                .map { $0.name.text }
        } else {
            return inputFunctionCalls
                .flatMap { $0.argumentList.map { $0.expression } }
                .compactMap { expr in
                    if let memberAccessExpr = expr as? MemberAccessExprSyntax {
                        return memberAccessExpr.name.text
                    } else if let functionCallExpr = expr as? FunctionCallExprSyntax,
                        let memberAccessExpr = functionCallExpr.calledExpression as? MemberAccessExprSyntax {
                        let identifier = memberAccessExpr.name.text
                        if let labelIdentifiers = functionCallExpr.labelIdentifiers() {
                            return identifier + labelIdentifiers
                        } else {
                            return identifier
                        }
                    }
                    return nil
            }
        }
    }()
    
    public lazy var outputIdentifiers: [String] = {
        if outputSwitchCases.isEmpty {
            return outputMemberAccesses
                .map { $0.name.text }
        } else {
            return outputSwitchCases
                .compactMap { $0.label as? SwitchCaseLabelSyntax }
                .flatMap { $0.caseItems
                    .compactMap { $0.pattern as? ExpressionPatternSyntax }
                    .compactMap { pattern in
                        if let memberAccessExpr = pattern.expression as? MemberAccessExprSyntax {
                            return memberAccessExpr.name.text
                        } else if let functionCallExpr = pattern.expression as? FunctionCallExprSyntax,
                            let memberAccessExpr = functionCallExpr.calledExpression as? MemberAccessExprSyntax {
                            return memberAccessExpr.name.text
                        }
                        return nil
                    }
            }
        }
    }()
    
    public init() {}
}

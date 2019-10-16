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
    public var inputsMemberAccesses: [MemberAccessExprSyntax] = []
    public var outputsFunctionCalls: [FunctionCallExprSyntax] = []
    public var outputsMemberAccesses: [MemberAccessExprSyntax] = []
    
    public init() {}
}

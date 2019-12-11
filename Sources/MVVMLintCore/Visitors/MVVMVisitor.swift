//
//  MVVMVisitor.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/12/11.
//

import Foundation
import SwiftSyntax

public protocol MVVMVisitor: SyntaxVisitor {
    associatedtype Syntax: ParsedSyntax

    var parsedSyntax: Syntax { get }
}

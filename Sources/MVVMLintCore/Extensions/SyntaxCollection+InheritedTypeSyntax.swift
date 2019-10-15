//
//  SyntaxCollection+InheritedTypeSyntax.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/11.
//

import Foundation
import SwiftSyntax

extension SyntaxCollection where Element == InheritedTypeSyntax {
    func containsViewModelType() -> Bool {
        let simpleInheritedTypes = self.compactMap { $0.typeName as? SimpleTypeIdentifierSyntax }
        guard simpleInheritedTypes.contains(where:  { $0.name.text.hasSuffix(ProtocolIdentifier.viewModelType.name) }) == true else {
            return false
        }
        return true
    }

    func containsViewModelInputsOutputsType() -> Bool {
        let types = ProtocolIdentifier.allCases.map { $0.name }
        let count = self.reduce(0, { result, type in
            if let simpleType = type.typeName as? SimpleTypeIdentifierSyntax,
                types.contains(where: { simpleType.name.text.hasSuffix($0) }) {
                return result + 1
            }
            return result
        })
        return count >= types.count
    }
}

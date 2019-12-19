//
//  ParameterClauseSyntax+LabelIdentifiers.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/12/19.
//

import Foundation
import SwiftSyntax

extension ParameterClauseSyntax {
    // labelIdentifiers returns label identifier such as (xxx:)
    func labelIdentifiers() -> String? {
        let labelIdentifiers = parameterList.compactMap { parameter -> String? in
            guard let label = parameter.firstName,
                label.text != "_", // ignore no labeled one because otuput doesn't have label to be compared
                let colon = parameter.colon else {
                return nil
            }
            return label.text + colon.text
        }

        guard !labelIdentifiers.isEmpty else {
            return nil
        }
        return ["(", labelIdentifiers.joined(), ")"].joined()
    }
}

extension FunctionCallExprSyntax {
    // labelIdentifiers is not used for now because output doesn't have label to be compared
    func labelIdentifiers() -> String? {
        let labelIdentifiers = argumentList.compactMap { argument -> String? in
            guard let label = argument.label,
                let colon = argument.colon else {
                return nil
            }
            return label.text + colon.text
        }

        guard !labelIdentifiers.isEmpty else {
            return nil
        }
        return ["(", labelIdentifiers.joined(), ")"].joined()
    }
}

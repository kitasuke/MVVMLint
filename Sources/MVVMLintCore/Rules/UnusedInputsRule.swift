//
//  UnusedInputsRule.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/12/13.
//

import Foundation
import SwiftSyntax

public class UnusedInputsRule {

    var viewModel: ParsedViewModel
    var viewController: ParsedViewController

    public init(viewModel: ParsedViewModel, viewController: ParsedViewController) {
        self.viewModel = viewModel
        self.viewController = viewController
    }

    public func run() -> [String] {
        let identifiers = viewController.inputIdentifiers
        let identifierTexts = identifiers.map { $0.text }
        let result = viewModel.inputIdentifiers.filter { identifier in
            return !identifierTexts.contains(identifier.text)
        }
        return result.map { $0.text }
    }
}

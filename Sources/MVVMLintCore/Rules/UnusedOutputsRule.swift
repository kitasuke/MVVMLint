//
//  UnusedOutputsRule.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/12/13.
//

public class UnusedOutputsRule {

    var viewModel: ParsedViewModel
    var viewController: ParsedViewController

    public init(viewModel: ParsedViewModel, viewController: ParsedViewController) {
        self.viewModel = viewModel
        self.viewController = viewController
    }

    public func run() -> [String] {
        let identifiers = viewController.outputIdentifiers
        let identifierTexts = identifiers.map { $0.text }

        // TODO: consider same identifier but different label/type
        // e.g. setValue(Int) vs setValue(String) or set(number:) vs set(string:)
        let result = viewModel.outputIdentifiers.filter { identifier in
            return !identifierTexts.contains(identifier.text)
        }
        return result.map { $0.text }
    }
}


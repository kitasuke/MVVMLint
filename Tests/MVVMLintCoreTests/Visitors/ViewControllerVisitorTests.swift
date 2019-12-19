//
//  ViewControllerVisitorTests.swift
//  MVVMLintCoreTests
//
//  Created by Yusuke Kita on 10/17/19.
//

import Foundation
import XCTest
import SwiftSyntax
@testable import MVVMLintCore

final class ViewControllerVisitorTests: FileManagableTestCase {

    func test_inputsFunctionCalls() {
        let input = """
class FooViewController {
    var viewModel: FooViewModel
    func viewDidLoad() {
        viewModel.apply(.viewDidLoad)
    }
    func buttonTapped() {
        closure { [weak self] in
            self?.viewModel.apply(.buttonTapped(data))
        }
    }
    func setValue() {
        viewModel.apply(.set(string: value))
    }
}
"""
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewControllerVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped", "set(string:)"],
            visitor.parsedSyntax.inputIdentifiers
        )
    }
    
    func test_outputsCaseLabelIdentifiers() {
        let input = """
class FooViewController {
    var viewModel: FooViewModel
    func bindViewModel() {
        viewModel.outputsObservable.subscribe { output in
            switch output {
            case .reloadData: break
            case .showError(let error): break
            }
        }
    }
}
"""
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewControllerVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.parsedSyntax.outputIdentifiers
        )
    }
    
    func test_inputsOutputsIdentifiers() {
        let input = """
class FooViewController {
    var viewModel: FooViewModel
    func viewDidLoad() {
        viewModel.apply(.viewDidLoad)
    }
    func buttonTapped() {
        closure { [weak self] in
            self?.viewModel.apply(.buttonTapped(data))
        }
    }

    func bindViewModel() {
        viewModel.outputsObservable.subscribe { output in
            switch output {
            case .reloadData: break
            case .showError(let error): break
            }
        }
    }
}
"""
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewControllerVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.parsedSyntax.inputIdentifiers
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.parsedSyntax.outputIdentifiers
        )
    }
    
    func test_inputsMemberAccessIdentifiers() {
        let input = """
class FooViewController: FooViewModelType {
    var viewModel: FooViewModel
    func viewDidLoad() {
        viewModel.inputs.viewDidLoad()
    }
    func buttonTapped() {
        closure { [weak self] in
            self?.viewModel.inputs.buttonTapped(data)
        }
    }
}
"""
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewControllerVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.parsedSyntax.inputIdentifiers
        )
    }
    
    func test_outputsMemberAccessIdentifiers() {
        let input = """
class FooViewController: FooViewModelType {
    var viewModel: FooViewModel
    func viewDidLoad() {
        view.apply(viewModel.outputs.title)
    }
    func bindViewModel() {
        viewModel.outputs.reloadData = { _ in }
        viewModel.outputs.showError = { _ in Error() }
    }
}
"""
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewControllerVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["title", "reloadData", "showError"],
            visitor.parsedSyntax.outputIdentifiers
        )
    }
    
    func test_inputsOutputsMemberAccessIdentifiers() {
        let input = """
class FooViewController: FooViewModelType {
    var viewModel: FooViewModel
    func viewDidLoad() {
        view.apply(viewModel.outputs.title)

        viewModel.inputs.viewDidLoad()
    }
    func buttonTapped() {
        closure { [weak self] in
            self?.viewModel.inputs.buttonTapped(data)
        }
    }

    func bindViewModel() {
        viewModel.outputs.reloadData = { _ in }
        viewModel.outputs.showError = { _ in Error() }
    }
}
"""

        let syntax = try! makeSyntax(from: input)
        var visitor = ViewControllerVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.parsedSyntax.inputIdentifiers
        )
        XCTAssertEqual(
            ["title", "reloadData", "showError"],
            visitor.parsedSyntax.outputIdentifiers
        )
    }
    
    private func makeSyntax(from input: String) throws -> SourceFileSyntax {
        let parser = Parser()
        let path = createSourceFile(from: input, suffix: "ViewController", foldername: foldername)
        return try parser.parseSyntax(path: path)
    }
}

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

final class ViewControllerVisitorTests: XCTestCase {
    func test_inputsFunctionCalls() {
        let input = """
        class FooViewController {
            var viewModel: FooViewModel
            func viewDidLoad() {
                viewModel.apply(.viewDidLoad)
            }
            func buttonTapped() {
                viewModel.apply(.buttonTapped(data))
            }
        }
        """
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewControllerVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.parsedViewController.inputsIdentifiers
        )
    }
    
    func test_outputsCaseLabelIdentifiers() {
        let input = """
        class FooViewController {
            var viewModel: FooViewModel
            func bindViewModel() {
                viewModel.outputsObservable.subscribe { output in
                    switch output {
                    case reloadData: break
                    case showError(let error): break
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
            visitor.parsedViewController.outputsIdentifiers
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
                viewModel.apply(.buttonTapped(data))
            }

            func bindViewModel() {
                viewModel.outputsObservable.subscribe { output in
                    switch output {
                    case reloadData: break
                    case showError(let error): break
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
            visitor.parsedViewController.inputsIdentifiers
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.parsedViewController.outputsIdentifiers
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
                viewModel.inputs.buttonTapped(data)
            }
        }
        """
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewControllerVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.parsedViewController.inputsIdentifiers
        )
    }
    
    func test_outputsMemberAccessIdentifiers() {
        let input = """
        class FooViewController: FooViewModelType {
            var viewModel: FooViewModel
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
            ["reloadData", "showError"],
            visitor.parsedViewController.outputsIdentifiers
        )
    }
    
    func test_inputsOutputsMemberAccessIdentifiers() {
        let input = """
        class FooViewController: FooViewModelType {
            var viewModel: FooViewModel
            func viewDidLoad() {
                viewModel.inputs.viewDidLoad()
            }
            func buttonTapped() {
                viewModel.inputs.buttonTapped(data)
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
            visitor.parsedViewController.inputsIdentifiers
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.parsedViewController.outputsIdentifiers
        )
    }
    
    private func makeSyntax(from input: String) throws -> SourceFileSyntax {
        let path = createSourceFile(from: input, suffix: "ViewController")
        let parser = Parser(file: File(path: path))
        return try parser.parseSyntax()
    }
}

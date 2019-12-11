//
//  ParserTests.swift
//  MVVMLintCoreTests
//
//  Created by Yusuke Kita on 2019/12/11.
//

import Foundation
import XCTest
@testable import MVVMLintCore

final class ParserTests: XCTestCase {
    func test_viewModelWithEnums() {
        let input = """
        class FooViewModel: ViewModelType {
            enum Inputs {
                case viewDidLoad
                case buttonTapped(Data)
            }
            enum Outputs {
                case reloadData
                case showError(Error)
            }
        }
        """

        let path = createSourceFile(from: input, suffix: "ViewModel")
        let parser = Parser(file: .init(path: path))
        var parsedSyntax = try! parser.parse() as! ParsedViewModel

        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            parsedSyntax.inputIdentifiers.map { $0.text }
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            parsedSyntax.outputIdentifiers.map { $0.text }
        )
    }

    func test_viewModelWithProtocols() {
        let input = """
        protocol FooViewModelInputs {
            func viewDidLoad()
            func buttonTapped(data: Data)
        }
        protocol FooViewModelOutputs {
            var reloadData: (() -> Void)? { get set }
            var showError: (() -> Error)? { get set }
        }
        protocol FooViewModelType {
            var inputs: FooViewModelInputs { get }
            var outputs: FooViewModelOutputs { get }
        }
        class FooViewModel: FooViewModelInputs, FooViewModelOutputs, FooViewModelType {}
        """

        let path = createSourceFile(from: input, suffix: "ViewModel")
        let parser = Parser(file: .init(path: path))
        var parsedSyntax = try! parser.parse() as! ParsedViewModel

        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            parsedSyntax.inputIdentifiers.map { $0.text }
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            parsedSyntax.outputIdentifiers.map { $0.text }
        )
    }

    func test_viewControllerWithEnums() {
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

        let path = createSourceFile(from: input, suffix: "ViewController")
        let parser = Parser(file: .init(path: path))
        var parsedSyntax = try! parser.parse() as! ParsedViewController

        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            parsedSyntax.inputIdentifiers.map { $0.text }
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            parsedSyntax.outputIdentifiers.map { $0.text }
        )
    }

    func test_viewControllerWithClosures() {
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

        let path = createSourceFile(from: input, suffix: "ViewController")
        let parser = Parser(file: .init(path: path))
        var parsedSyntax = try! parser.parse() as! ParsedViewController

        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            parsedSyntax.inputIdentifiers.map { $0.text }
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            parsedSyntax.outputIdentifiers.map { $0.text }
        )
    }
}

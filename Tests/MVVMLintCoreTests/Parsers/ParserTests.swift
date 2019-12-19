//
//  ParserTests.swift
//  MVVMLintCoreTests
//
//  Created by Yusuke Kita on 2019/12/11.
//

import Foundation
import XCTest
@testable import MVVMLintCore

final class ParserTests: FileManagableTestCase {

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

        let parser = Parser()
        let file = makeViewModel(from: input)
        var parsedSyntax = try! parser.parse(fileType: file)

        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            parsedSyntax.inputIdentifiers
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            parsedSyntax.outputIdentifiers
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

            var title: String? { get }
        }
        protocol FooViewModelType {
            var inputs: FooViewModelInputs { get }
            var outputs: FooViewModelOutputs { get }
        }
        class FooViewModel: FooViewModelInputs, FooViewModelOutputs, FooViewModelType {}
        """

        let parser = Parser()
        let file = makeViewModel(from: input)
        var parsedSyntax = try! parser.parse(fileType: file)

        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            parsedSyntax.inputIdentifiers
        )
        XCTAssertEqual(
            ["reloadData", "showError", "title"],
            parsedSyntax.outputIdentifiers
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
                    case .reloadData: break
                    case .showError(let error): break
                    }
                }
            }
        }
        """

        let parser = Parser()
        let file = makeViewController(from: input)
        var parsedSyntax = try! parser.parse(fileType: file)

        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            parsedSyntax.inputIdentifiers
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            parsedSyntax.outputIdentifiers
        )
    }

    func test_viewControllerWithClosures() {
        let input = """
        class FooViewController: FooViewModelType {
            var viewModel: FooViewModel
            func viewDidLoad() {
                viewModel.inputs.viewDidLoad()

                view.apply(viewModel.outputs.title)
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

        let parser = Parser()
        let file = makeViewController(from: input)
        var parsedSyntax = try! parser.parse(fileType: file)

        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            parsedSyntax.inputIdentifiers
        )
        XCTAssertEqual(
            ["title", "reloadData", "showError"],
            parsedSyntax.outputIdentifiers
        )
    }

    private func makeViewModel(from input: String) -> ViewModelFile {
        let path = createSourceFile(from: input, suffix: "ViewModel", foldername: foldername)
        return ViewModelFile(path: path)
    }

    private func makeViewController(from input: String) -> ViewControllerFile {
        let path = createSourceFile(from: input, suffix: "ViewController", foldername: foldername)
        return ViewControllerFile(path: path)
    }
}

//
//  UnusedInputsRuleTests.swift
//  MVVMLintCoreTests
//
//  Created by Yusuke Kita on 2019/12/13.
//

import Foundation
import XCTest
@testable import MVVMLintCore

final class UnusedInputsRuleTests: XCTestCase {

    func test_unusedEnumInputs() {
        let filename = UUID().uuidString
        _ = createSourceFile(from: """
            class FooViewModel: ViewModelType {
                enum Inputs {
                    case viewDidLoad
                    case buttonTapped(Data)
                    case unusedInput
                }
            }
""", suffix: "ViewModel", filename: filename)
        _ = createSourceFile(from: """
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
            }

""", suffix: "ViewController", filename: filename)

        let (parsedViewModel, parsedViewController) = makeParsed()
        let result = UnusedInputsRule(viewModel: parsedViewModel, viewController: parsedViewController).run()
        XCTAssertEqual(
            ["unusedInput"],
            result
        )
    }

    func test_unusedIdentifierInputs() {
        let filename = UUID().uuidString
        _ = createSourceFile(from: """
            protocol FooViewModelInputs {
                func viewDidLoad()
                func buttonTapped(data: Data)
                func unusedInput()
            }
            protocol FooViewModelType {
                var inputs: FooViewModelInputs { get }
            }
            class FooViewModel: FooViewModelInputs, FooViewModelOutputs, FooViewModelType {}
""", suffix: "ViewModel", filename: filename)
        _ = createSourceFile(from: """
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

""", suffix: "ViewController", filename: filename)

        let (parsedViewModel, parsedViewController) = makeParsed()
        let result = UnusedInputsRule(viewModel: parsedViewModel, viewController: parsedViewController).run()
        XCTAssertEqual(
            ["unusedInput"],
            result
        )
    }

    private func makeParsed() -> (ParsedViewModel, ParsedViewController) {
        let path = NSTemporaryDirectory()
        let scanner = FileScanner(paths: [path])
        let pair = scanner.scan().first!
        let parser = Parser()
        let parsedViewModel = try! parser.parse(fileType: pair.viewModel)
        let parsedViewController = try! parser.parse(fileType: pair.viewController)
        return (parsedViewModel, parsedViewController)
    }
}

//
//  UnusedInputsRuleTests.swift
//  MVVMLintCoreTests
//
//  Created by Yusuke Kita on 2019/12/13.
//

import Foundation
import XCTest
@testable import MVVMLintCore

final class UnusedInputsRuleTests: FileManagableTestCase {

    func test_unusedEnumInputs() {
        let filename = UUID().uuidString
        _ = createSourceFile(from: """
class FooViewModel: ViewModelType {
    enum Inputs {
        case viewDidLoad
        case buttonTapped(Data)
        case unusedInput
        case set(number: Int)
        case set(string: String)
        case setValue(_ value: Value)
    }
}
""", suffix: "ViewModel", foldername: foldername, filename: filename)
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
    func setValue() {
        viewModel.apply(.set(number: number))
        viewModel.apply(.setValue(value))
    }
}
""", suffix: "ViewController", foldername: foldername, filename: filename)

        let (parsedViewModel, parsedViewController) = makeParsed()
        let result = UnusedInputsRule(viewModel: parsedViewModel, viewController: parsedViewController).run()
        XCTAssertEqual(
            ["unusedInput", "set(string:)"],
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
    func setValue(Int)
    func setValue(String)
}
protocol FooViewModelType {
    var inputs: FooViewModelInputs { get }
}
class FooViewModel: FooViewModelInputs, FooViewModelOutputs, FooViewModelType {}
""", suffix: "ViewModel", foldername: foldername, filename: filename)
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
    func setValue(_ value: Int) {
        viewModel.inputs.setValue(value)
    }
}
""", suffix: "ViewController", foldername: foldername, filename: filename)

        let (parsedViewModel, parsedViewController) = makeParsed()
        let result = UnusedInputsRule(viewModel: parsedViewModel, viewController: parsedViewController).run()
        XCTAssertEqual(
            ["unusedInput"], // setValue(String) should be detected
            result
        )
    }

    private func makeParsed() -> (ParsedViewModel, ParsedViewController) {
        let scanner = FileScanner(paths: [tempDirectory.path])
        let pair = scanner.scan().first!
        let parser = Parser()
        let parsedViewModel = try! parser.parse(fileType: pair.viewModel)
        let parsedViewController = try! parser.parse(fileType: pair.viewController)
        return (parsedViewModel, parsedViewController)
    }
}

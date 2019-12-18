//
//  UnusedOutputsRuleTests.swift
//  MVVMLintCoreTests
//
//  Created by Yusuke Kita on 2019/12/16.
//

import Foundation
import XCTest
@testable import MVVMLintCore

final class UnusedOutputsRuleTests: FileManagableTestCase {

    func test_unusedEnumOutputs() {
        let filename = UUID().uuidString
        _ = createSourceFile(from: """
class FooViewModel: ViewModelType {
    enum Outputs {
        case reloadData
        case showError(Error)
        case unusedOutput
        case set(number: Int)
        case set(string: String)
    }
}
""", suffix: "ViewModel", foldername: foldername, filename: filename)
        _ = createSourceFile(from: """
class FooViewController {
    var viewModel: FooViewModel
    func bindViewModel() {
        viewModel.outputsObservable.subscribe { output in
            switch output {
            case .reloadData: break
            case .showError(let error): break
            case .set(let number): break
            }
        }
    }
}
""", suffix: "ViewController", foldername: foldername, filename: filename)

        let (parsedViewModel, parsedViewController) = makeParsed()
        let result = UnusedOutputsRule(viewModel: parsedViewModel, viewController: parsedViewController).run()
        XCTAssertEqual(
            ["unusedOutput"], // set(let number) should be detected
            result
        )
    }

    func test_unusedIdentifierInputs() {
        let filename = UUID().uuidString
        _ = createSourceFile(from: """
protocol FooViewModelInputs {}
protocol FooViewModelOutputs {
    var reloadData: (() -> Void)? { get set }
    var showError: (() -> Error)? { get set }
    var unusedOutput: (() -> Void)? { get set }
    var setValue: ((Int) -> Void)? { get set }
    var setValue: ((String) -> Void)? { get set }

    var title: String? { get }
}
protocol FooViewModelType {
    var inputs: FooViewModelInputs { get }
    var outputs: FooViewModelOutputs { get }
}
class FooViewModel: FooViewModelInputs, FooViewModelOutputs, FooViewModelType {}
""", suffix: "ViewModel", foldername: foldername, filename: filename)
        _ = createSourceFile(from: """
class FooViewController: FooViewModelType {
    var viewModel: FooViewModel
    func viewDidLoad() {
        view.apply(viewModel.outputs.title)
    }
    func bindViewModel() {
        viewModel.outputs.reloadData = { _ in }
        viewModel.outputs.showError = { _ in Error() }
        viewModel.outputs.setValue = { _ in }
    }
}
""", suffix: "ViewController", foldername: foldername, filename: filename)

        let (parsedViewModel, parsedViewController) = makeParsed()
        let result = UnusedOutputsRule(viewModel: parsedViewModel, viewController: parsedViewController).run()
        XCTAssertEqual(
            ["unusedOutput"], // setValue(String) should be detected
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

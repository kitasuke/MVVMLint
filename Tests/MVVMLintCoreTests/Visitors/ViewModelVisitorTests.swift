//
//  ViewModelVisitorTests.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 10/16/19.
//

import Foundation
import XCTest
import SwiftSyntax
@testable import MVVMLintCore

final class ViewModelVisitorTests: XCTestCase {
    func test_inputsEnumCases() {
        let input = """
        class FooViewModel: ViewModelType {
            enum Inputs {
                case viewDidLoad
                case buttonTapped(Data)
            }
        }
        """
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewModelVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.parsedViewModel.inputsIdentifiers
        )
    }
    
    func test_outputsEnumCases() {
        let input = """
        class FooViewModel: ViewModelType {
            enum Outputs {
                case reloadData
                case showError(Error)
            }
        }
        """
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewModelVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.parsedViewModel.outputsIdentifiers
        )
    }
    
    func test_inputsOutputsEnumCases() {
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
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewModelVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.parsedViewModel.inputsIdentifiers
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.parsedViewModel.outputsIdentifiers
        )
    }
    
    func test_inputsDeclIdentifiers() {
        let input = """
        protocol FooViewModelInputs {
            func viewDidLoad()
            func buttonTapped(data: Data)
        }
        protocol FooViewModelOutputs {}
        protocol FooViewModelType {
            var inputs: FooViewModelInputs { get }
            var outputs: FooViewModelOutputs { get }
        }
        class FooViewModel: FooViewModelInputs, FooViewModelOutputs, FooViewModelType {}
        """
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewModelVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.parsedViewModel.inputsIdentifiers
        )
    }
    
    func test_outputsDeclIdentifiers() {
        let input = """
        protocol FooViewModelInputs {}
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
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewModelVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.parsedViewModel.outputsIdentifiers
        )
    }
    
    func test_inputsOutputsDeclIdentifiers() {
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

        let syntax = try! makeSyntax(from: input)
        var visitor = ViewModelVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.parsedViewModel.inputsIdentifiers
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.parsedViewModel.outputsIdentifiers
        )
    }
    
    private func makeSyntax(from input: String) throws -> SourceFileSyntax {
        let path = createSourceFile(from: input, suffix: "ViewModel")
        let parser = Parser(file: File(path: path))
        return try parser.parseSyntax()
    }
}
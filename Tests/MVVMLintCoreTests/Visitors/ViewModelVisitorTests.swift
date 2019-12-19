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

final class ViewModelVisitorTests: FileManagableTestCase {

    func test_inputsEnumCases() {
        let input = """
        class FooViewModel: ViewModelType {
            enum Inputs {
                case viewDidLoad
                case buttonTapped(Data)
                case set(string: String)
                case setValue(_ value: Value)
            }
        }
        """
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewModelVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped", "set(string:)", "setValue"],
            visitor.parsedSyntax.inputIdentifiers
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
            visitor.parsedSyntax.outputIdentifiers
        )
    }
    
    func test_inputsOutputsEnumCases() {
        let input = """
        class FooViewModel: ViewModelType {
            enum Inputs {
                case viewDidLoad
                case buttonTapped(Data)
                case set(string: String)
                case setValue(_ value: Value)
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
            ["viewDidLoad", "buttonTapped", "set(string:)", "setValue"],
            visitor.parsedSyntax.inputIdentifiers
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.parsedSyntax.outputIdentifiers
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
            visitor.parsedSyntax.inputIdentifiers
        )
    }
    
    func test_outputsDeclIdentifiers() {
        let input = """
        protocol FooViewModelInputs {}
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
        
        let syntax = try! makeSyntax(from: input)
        var visitor = ViewModelVisitor()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["reloadData", "showError", "title"],
            visitor.parsedSyntax.outputIdentifiers
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

            var title: String? { get }
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
            visitor.parsedSyntax.inputIdentifiers
        )
        XCTAssertEqual(
            ["reloadData", "showError", "title"],
            visitor.parsedSyntax.outputIdentifiers
        )
    }

    private func makeSyntax(from input: String) throws -> SourceFileSyntax {
        let parser = Parser()
        let path = createSourceFile(from: input, suffix: "ViewModel", foldername: foldername)
        return try parser.parseSyntax(path: path)
    }
}

//
//  ViewModelInspectorTests.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 10/16/19.
//

import Foundation
import XCTest
import SwiftSyntax
@testable import MVVMLintCore

final class ViewModelInspectorTests: XCTestCase {
    func test_inputsEnumCases() {
        let input = """
        class FooViewModel: ViewModelType {
            enum Inputs {
                case viewDidLoad
                case buttonTapped(Data)
            }
        }
        """
        
        let path = createSourceFile(from: input, suffix: "ViewModel")
        let syntax = try! makeSyntax(for: path)
        var visitor = ViewModelInspector()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.viewModelSyntax.inputsCaseIdentifiers
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
        
        let path = createSourceFile(from: input, suffix: "ViewModel")
        let syntax = try! makeSyntax(for: path)
        var visitor = ViewModelInspector()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.viewModelSyntax.outputsCaseIdentifiers
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
        
        let path = createSourceFile(from: input, suffix: "ViewModel")
        let syntax = try! makeSyntax(for: path)
        var visitor = ViewModelInspector()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.viewModelSyntax.inputsCaseIdentifiers
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.viewModelSyntax.outputsCaseIdentifiers
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
        
        let path = createSourceFile(from: input, suffix: "ViewModel")
        let syntax = try! makeSyntax(for: path)
        var visitor = ViewModelInspector()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.viewModelSyntax.inputsDeclIdentifiers
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
        
        let path = createSourceFile(from: input, suffix: "ViewModel")
        let syntax = try! makeSyntax(for: path)
        var visitor = ViewModelInspector()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.viewModelSyntax.outputDeclIdentifiers
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
        
        let path = createSourceFile(from: input, suffix: "ViewModel")
        let syntax = try! makeSyntax(for: path)
        var visitor = ViewModelInspector()
        syntax.walk(&visitor)
        XCTAssertEqual(
            ["viewDidLoad", "buttonTapped"],
            visitor.viewModelSyntax.inputsDeclIdentifiers
        )
        XCTAssertEqual(
            ["reloadData", "showError"],
            visitor.viewModelSyntax.outputDeclIdentifiers
        )
    }
    
    private func makeSyntax(for path: String) throws -> SourceFileSyntax {
        let parser = FileParser(path: path)
        return try parser.parse()
    }
}

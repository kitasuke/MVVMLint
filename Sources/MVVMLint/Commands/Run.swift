//
//  Run.swift
//  Commandant
//
//  Created by Yusuke Kita on 2019/12/18.
//

import Foundation
import Commandant
import MVVMLintCore

struct RunCommand: CommandProtocol {

    typealias Options = RunOptions
    typealias ClientError = Error

    let verb = "run"
    let function = "Display duplicated strings"

    func run(_ options: Options) -> Result<(), ClientError> {

        let scanner = FileScanner(paths: options.paths)
        let pairs = scanner.scan()
        for pair in pairs {
            do {
                let parser = Parser()
                let parsedViewModel = try parser.parse(fileType: pair.viewModel)
                let parsedViewController = try parser.parse(fileType: pair.viewController)

                let inputs = UnusedInputsRule(viewModel: parsedViewModel, viewController: parsedViewController).run()
                if !inputs.isEmpty {
                    print("input: \(inputs.joined(separator: ", ")) not called at: \(pair.viewController.path)")
                }

                let outputs = UnusedOutputsRule(viewModel: parsedViewModel, viewController: parsedViewController).run()
                if !outputs.isEmpty {
                    print("output: \(outputs.joined(separator: ", ")) not called at: \(pair.viewController.path)")
                }
            } catch let error {
                return .failure(error)
            }
        }

        return .success(())
    }
}

struct RunOptions: OptionsProtocol {

    typealias ClientError = Error

    fileprivate let paths: [String]
    fileprivate let ignoreHidden: Bool
    fileprivate let ignoreTest: Bool
    fileprivate let ignorePaths: [String]
    private init(
        paths: [String],
        ignoreHidden: Bool,
        ignoreTest: Bool,
        ignorePaths: [String]
    ) {
        self.paths = paths
        self.ignoreHidden = ignoreHidden
        self.ignoreTest = ignoreTest
        self.ignorePaths = ignorePaths
    }

    private static func create(_ paths: [String]) -> (Bool) -> (Bool) -> ([String]) -> RunOptions {
        return { ignoreHidden in
            return { ignoreTest in
                return { ignorePaths in
                    RunOptions(
                        paths: paths,
                        ignoreHidden: ignoreHidden,
                        ignoreTest: ignoreTest,
                        ignorePaths: ignorePaths
                    )
                }
            }
        }
    }

    static func evaluate(_ m: CommandMode) -> Result<RunOptions, CommandantError<ClientError>> {
        return create
            <*> m <| Option(key: "paths", defaultValue: ["."], usage: "paths to run")
            <*> m <| Option(key: "ignoreHidden", defaultValue: true, usage: "flag whether it ignores hidden files")
            <*> m <| Option(key: "ignoreTest", defaultValue: true, usage: "flag whether it ignores test files")
            <*> m <| Option(key: "ignorePaths", defaultValue: [], usage: "paths to ignore")
    }
}

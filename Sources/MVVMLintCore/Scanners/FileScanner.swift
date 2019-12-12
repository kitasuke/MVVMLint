//
//  FileScanner.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/02.
//

import Foundation

public struct FileScanner {

    let paths: [String]

    public init(paths: [String]) {
        self.paths = paths
    }

    public func scan() -> [FilePair] {
        let iterator = FileIterator(paths: paths)

        var viewControllerFiles: [ViewControllerFile] = []
        var viewModelFiles: [ViewModelFile] = []
        for path in iterator {
            let kind = FileKind(path: path)
            switch kind {
            case .viewModel:
                viewModelFiles.append(.init(path: path))
            case .viewController:
                viewControllerFiles.append(.init(path: path))
            default:
                break
            }
        }

        let pairs: [FilePair] = viewModelFiles
            .compactMap { viewModel in
                let targetPath = viewModel.asViewControllerPath()
                let filePath = URL(string: targetPath)!.appendingPathExtension("swift").absoluteString
                guard let viewController = viewControllerFiles.first(where: { $0.path == filePath }) else {
                    return nil
                }
                return .init(viewModel: viewModel, viewController: viewController)
        }
        return pairs
    }
}

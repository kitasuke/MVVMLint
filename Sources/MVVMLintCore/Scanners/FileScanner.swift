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

        var viewControllerFiles: [File] = []
        var viewModelFiles: [File] = []
        for file in iterator {
            switch file.kind {
            case .viewModel:
                viewModelFiles.append(file)
            case .viewController:
                viewControllerFiles.append(file)
            default:
                break
            }
        }

        var pairs: [FilePair] = []
        for viewModel in viewModelFiles {
            let endIndex = viewModel.pathWithoutExtension.endIndex
            let index = viewModel.pathWithoutExtension.index(endIndex, offsetBy: -FileKind.viewModel.identifier.count)
            let targetPath = viewModel.pathWithoutExtension.replacingCharacters(in: index..<endIndex, with: FileKind.viewController.identifier)
            let filePath = URL(string: targetPath)!.appendingPathExtension(File.extension).absoluteString
            let file = File(path: filePath)
            guard let viewController = viewControllerFiles.first(where: { $0.path == file.path }) else {
                continue
            }
            pairs.append(.init(files: [viewModel, viewController]))
        }
        return pairs
    }
}

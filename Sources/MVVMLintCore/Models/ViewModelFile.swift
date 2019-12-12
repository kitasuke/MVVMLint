//
//  ViewModelFile.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/12/12.
//

import Foundation

public struct ViewModelFile: FileType {
    public var path: String
    public var url: URL
    public var visitor = ViewModelVisitor()

    init(path: String) {
        guard let url = URL(string: path) else {
            fatalError("invalid path")
        }
        self.path = path
        self.url = url
    }

    func asViewControllerPath() -> String {
        let endIndex = pathWithoutExtension.endIndex
        let index = pathWithoutExtension.index(endIndex, offsetBy: -FileKind.viewModel.identifier.count)
        let targetPath = pathWithoutExtension.replacingCharacters(in: index..<endIndex, with: FileKind.viewController.identifier)
        return targetPath
    }
}

//
//  File.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/03.
//

import Foundation

public struct File {
    public var kind: FileKind
    public var path: String
    public var pathWithoutExtension: String
    public var name: String

    init(path: String) {
        guard let url = URL(string: path) else {
            fatalError("invalid path")
        }

        self.path = path
        let urlDeletingPathExtension = url.deletingPathExtension()
        self.pathWithoutExtension = urlDeletingPathExtension.absoluteString
        self.name = urlDeletingPathExtension.lastPathComponent
        self.kind = FileKind(name: self.name)
    }
}

extension File {
    public static let `extension` = "swift"
}

extension File {
    func asViewControllerPath() -> String {
        guard self.kind == .viewModel else {
            return self.path
        }

        let endIndex = self.pathWithoutExtension.endIndex
        let index = self.pathWithoutExtension.index(endIndex, offsetBy: -FileKind.viewModel.identifier.count)
        let targetPath = self.pathWithoutExtension.replacingCharacters(in: index..<endIndex, with: FileKind.viewController.identifier)
        return targetPath
    }
}

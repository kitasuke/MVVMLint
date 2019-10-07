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
    public static let `extension` = "swift"

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

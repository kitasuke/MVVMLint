//
//  ViewControllerFile.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/12/12.
//

import Foundation

public struct ViewControllerFile: FileType {
    public var path: String
    public var url: URL
    public var visitor = ViewControllerVisitor()

    init(path: String) {
        guard let url = URL(string: path) else {
            fatalError("invalid path")
        }
        self.path = path
        self.url = url
    }
}

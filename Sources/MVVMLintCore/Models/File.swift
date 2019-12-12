//
//  File.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/03.
//

import Foundation

public protocol FileType {
    associatedtype VisitorType: MVVMVisitor

    var path: String { get }
    var url: URL { get }
    var visitor: VisitorType { get }
}

extension FileType {
    public var name: String {
        return url.deletingPathExtension().lastPathComponent
    }
    public var pathWithoutExtension: String {
        return url.deletingPathExtension().absoluteString
    }
}

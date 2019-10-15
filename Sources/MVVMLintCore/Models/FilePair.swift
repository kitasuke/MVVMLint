//
//  FilePair.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/03.
//

import Foundation

public struct FilePair {
    public var files: [File]
    public var viewModel: File
    public var viewController: File

    public init(files: [File]) {
        self.files = files
        guard let viewModel = files.first(where: { $0.kind == .viewModel }),
            let viewController = files.first(where: { $0.kind == .viewController }) else {
            fatalError()
        }

        self.viewModel = viewModel
        self.viewController = viewController
    }
}

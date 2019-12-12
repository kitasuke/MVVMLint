//
//  FilePair.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/03.
//

import Foundation

public struct FilePair {
    public var viewModel: ViewModelFile
    public var viewController: ViewControllerFile

    public init(viewModel: ViewModelFile, viewController: ViewControllerFile) {
        self.viewModel = viewModel
        self.viewController = viewController
    }
}

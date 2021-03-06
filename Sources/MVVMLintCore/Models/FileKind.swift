//
//  FileKind.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/03.
//

import Foundation

public enum FileKind {
    case viewModel, viewController, others

    public var identifier: String {
        switch self {
        case .viewModel: return "ViewModel"
        case .viewController: return "ViewController"
        case .others: return ""
        }
    }

    init(path: String) {
        guard let url = URL(string: path) else {
            fatalError()
        }
        let name = url.deletingPathExtension().lastPathComponent
        if name.hasSuffix(FileKind.viewModel.identifier) {
            self = .viewModel
        } else if name.hasSuffix(FileKind.viewController.identifier) {
            self = .viewController
        } else {
            self = .others
        }
    }

    init(name: String) {
        if name.hasSuffix(FileKind.viewModel.identifier) {
            self = .viewModel
        } else if name.hasSuffix(FileKind.viewController.identifier) {
            self = .viewController
        } else {
            self = .others
        }
    }
}

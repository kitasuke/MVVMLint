//
//  ProtocolIdentifier.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/11.
//

import Foundation

enum ProtocolIdentifier: CaseIterable {
    case viewModelType, inputs, outputs

    var name: String {
        switch self {
        case .viewModelType: return "ViewModelType"
        case .inputs: return "ViewModelInputs"
        case .outputs: return "ViewModelOutputs"
        }
    }
}

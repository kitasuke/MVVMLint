//
//  Version.swift
//  MVVMLint
//
//  Created by Yusuke Kita on 2019/12/18.
//

import Foundation
import Commandant

struct VersionCommand: CommandProtocol {

    typealias Options = NoOptions<Error>

    let verb = "version"
    let function = "Display current version of swiftconst"

    func run(_ options: Options) -> Result<(), Error> {
        print("0.1.0")
        return .success(())
    }
}


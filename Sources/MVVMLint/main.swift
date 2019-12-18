//
//  main.swift
//  MVVMLint
//
//  Created by Yusuke Kita on 2019/10/02.
//

import Foundation
import Commandant

let registry = CommandRegistry<Error>()

registry.register(RunCommand())
registry.register(VersionCommand())
let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: helpCommand.verb) { error in
    fputs("\(error)\n", stderr)
}

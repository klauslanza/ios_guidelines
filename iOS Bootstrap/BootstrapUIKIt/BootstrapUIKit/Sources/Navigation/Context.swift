//
//  Context.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation
import BootstrapCore

public struct Context {
    public let core: Core
    public let navigator: Navigator
//    public let messenger: Messenger
    
    public init(core: Core, navigator: Navigator) { // messenger: Messenger)
        self.core = core
        self.navigator = navigator
    }
}

//
//  VoidCoordinator.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

open class VoidCoordinator<View: Coordinable>: BaseCoordinator<View, Void> {
    public init(context: Context) {
        super.init(context: context, param: Void())
    }
}

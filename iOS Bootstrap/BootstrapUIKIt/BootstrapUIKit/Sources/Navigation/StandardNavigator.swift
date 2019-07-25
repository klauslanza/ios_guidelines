//
//  StandardNavigator.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public final class StandardNavigator: NSObject {
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private var mainCoordinator: MainCoordinable?
    
    override public init() {
        super.init()
        FontWeight.loadAllFonts()
    }
}

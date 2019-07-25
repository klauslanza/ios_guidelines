//
//  BaseCoordinator.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation
import BootstrapShared
import BootstrapCore

open class BaseCoordinator<View: Coordinable, Param>: Coordinator {
    public let context: Context
    public var param: Param
    
    // swiftlint:disable implicitly_unwrapped_optional
    public weak var view: View!
    // swiftlint:enable implicitly_unwrapped_optional
    
    public init(context: Context, param: Param) {
        self.context = context
        self.param = param
    }
    
    deinit {
        Logger.log(level: .debug, category: "deinit", text: "\(type(of: self))")
    }
    
    public final func start() -> UIViewController {
        // swiftlint:disable force_cast
        let coordinator = self as! View.Coordinator
        let viewController = create(coordinator: coordinator) as! UIViewController
        viewDidCreate()
        return viewController
        // swiftlint:enable force_cast
    }
    
    private func create(coordinator: View.Coordinator) -> View {
        // !! DO NOT TOUCH !!
        let viewController = View(coordinator: coordinator)
        view = viewController
        // !! DO NOT TOUCH !!
        return viewController
    }
    
    // override
    open func viewDidCreate() {
    }
}

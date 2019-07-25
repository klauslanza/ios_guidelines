//
//  Navigator.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 25/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public protocol Navigator {
    
    @discardableResult
    func start(coordinator: Coordinator) -> UIWindow
    
    // main
    func set(root: Coordinator)

    // presentation
    func present(viewController: UIViewController, presentationStyle: UIModalPresentationStyle)
    
//    // navigation
//    func navigate(to coordinator: Coordinator)
//    func navigate(to coordinator: Coordinator, presenter: Presenter)
//
//    // dismiss
//    func dismiss()
//    func dismissToRoot(completion: @escaping () -> Void)
//    func dismiss(completion: @escaping () -> Void)
}

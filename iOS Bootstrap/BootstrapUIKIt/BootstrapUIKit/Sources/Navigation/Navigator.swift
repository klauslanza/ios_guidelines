//
//  Navigator.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 25/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public protocol Navigator {
    // main
    @discardableResult
    func start(coordinator: Coordinator) -> UIWindow
    func set(root: Coordinator)
    // presentation & navigation
    func present(viewController: UIViewController, presentationStyle: UIModalPresentationStyle)
    func navigate(to coordinator: Coordinator)
    func navigate(to coordinator: Coordinator, presenter: Presenter)
    // dismiss
    func dismiss()
    func dismissToRoot(completion: @escaping () -> Void)
    func dismiss(completion: @escaping () -> Void)
    // browser
    func open(url: String)
    func safari(url: String)
}

public extension Navigator {
    func dismissToRoot() {
        self.dismissToRoot {}
    }
    
    func present(viewController: UIViewController) {
        present(viewController: viewController, presentationStyle: .fullScreen)
    }
}

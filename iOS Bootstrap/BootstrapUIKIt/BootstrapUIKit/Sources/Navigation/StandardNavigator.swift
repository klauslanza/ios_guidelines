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

extension StandardNavigator: Navigator {
    
    @discardableResult
    /// Launch coordinator as the starting point of the navigation
    ///
    /// - Parameter coordinator: The coordinator to show.
    /// - Returns: Visibile UIWindow
    public func start(coordinator: Coordinator) -> UIWindow {
        if window.rootViewController == nil {
            window.rootViewController = UINavigationController(rootViewController: coordinator.start())
            window.makeKeyAndVisible()
        } else {
            // TODO: Dismiss previous stack controllers
            var root = coordinator.start()
            if !(root is UITabBarController) && !(root is UINavigationController) {
                root = root.embeddedInNav()
            }
            
            // If this is the main container, keep the reference
            if let main = coordinator as? MainCoordinable {
                mainCoordinator = main
            }
            
            let options: UIView.AnimationOptions = [.transitionCrossDissolve, .showHideTransitionViews, .layoutSubviews, .allowAnimatedContent]
            UIView.transition(with: window, duration: 0.5, options: options, animations: {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.window.rootViewController = root
                UIView.setAnimationsEnabled(oldState)
            }, completion: { _ in
                // Put here actions to do after entering animation (example: manage deeplinking)
            })
        }
        
        return window
    }
    
    public func set(root: Coordinator) {
        guard let main = mainCoordinator else { return }
        main.set(root: root, animated: false)
    }
    
    public func present(viewController: UIViewController, presentationStyle: UIModalPresentationStyle) {
        viewController.modalPresentationStyle = presentationStyle
        window.rootViewController?.present(viewController, animated: true)
    }
}

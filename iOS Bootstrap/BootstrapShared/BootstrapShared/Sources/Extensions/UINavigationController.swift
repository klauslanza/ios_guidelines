//
//  UINavigationController.swift
//  BootstrapShared
//
//  Created by Klaus Lanzarini on 26/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

extension UINavigationController {
    override open var childForStatusBarStyle: UIViewController? {
        return viewControllers.last
    }
    
    override open var childForStatusBarHidden: UIViewController? {
        return viewControllers.last
    }
    
    public func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    public func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)
        
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}

//
//  UIViewController.swift
//  BootstrapShared
//
//  Created by Klaus Lanzarini on 26/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation
import SafariServices

public extension UIViewController {
    func findFinalPresented(from viewController: UIViewController) -> UIViewController {
        if let presented = viewController.presentedViewController, !(presented is SFSafariViewController) {
            return findFinalPresented(from: presented)
        }
        
        return viewController
    }
    
    func findLastViewController(from viewController: UIViewController) -> UIViewController {
        if let nvc = self as? UINavigationController {
            return nvc.visibleViewController ?? self
        }
        
        return self
    }
    
    var lastViewController: UIViewController? {
        if let nvc = self as? UINavigationController {
            return nvc.visibleViewController
        }
        
        if let pvc = self.presentedViewController {
            return pvc
        }
        
        return self
    }
    
    var topMostViewController: UIViewController? {
        if let tbc = self as? UITabBarController {
            if let selected = tbc.selectedViewController {
                return findFinalPresented(from: selected)
            }
        }
        
        if let nvc = self as? UINavigationController {
            return findFinalPresented(from: nvc)
        }
        
        return self
    }
    
    var leafViewController: UIViewController? {
        if let tbc = self as? UITabBarController {
            if let selected = tbc.selectedViewController {
                return findLastViewController(from: selected)
            }
        }
        
        return findLastViewController(from: self)
    }
}

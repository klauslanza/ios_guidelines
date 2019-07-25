//
//  UIViewController.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 25/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public extension UIViewController {
    func embeddedInNav() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    static func makeViewControllerFromNib<T>() -> T where T: UIViewController {
        guard let view: T = self.viewControllerFromNib() else {
            fatalError("Not a valid view type!!")
        }
        
        return view
    }
    
    private static func viewControllerFromNib<T>() -> T? where T: UIViewController {
        let bundle = Bundle(for: self)
        
        return T(nibName: String(describing: self), bundle: bundle)
    }
}

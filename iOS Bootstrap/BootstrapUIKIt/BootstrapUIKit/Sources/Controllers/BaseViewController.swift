//
//  BaseViewController.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation
import BootstrapShared

public protocol Coordinable: class {
    associatedtype Coordinator
    init(coordinator: Coordinator)
}

public protocol Layoutable: class {
    var navigationBarLayout: NavigationBarLayout { get set }
}

protocol Childable: class {
    var isChild: Bool { get set }
}

open class BaseViewController<C>: UIViewController, Coordinable, Layoutable, Childable {
    public let coordinator: C
    
    public var isChild: Bool = false
    public var previousNavigationBarLayout: NavigationBarLayout?
    public var navigationBarLayout: NavigationBarLayout = .base
    
    public required init(coordinator: C) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.configure()
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Logger.log(level: .debug, category: "deinit", text: "\(type(of: self))")
    }
    
    open func configure() {
    }
    
    override open func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationBar = navigationController?.navigationBar, isChild == false {
            navigationBarLayout.apply(to: navigationBar)
        }
        
        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard isChild == false else { return }
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        if let coordinator = transitionCoordinator {
            self.navigationBarLayout.apply(to: navigationBar)
            coordinator.animate(alongsideTransition: { _ in
                self.navigationBarLayout.apply(to: navigationBar)
            }, completion: { _ in
                self.navigationBarLayout.apply(to: navigationBar)
            })
        } else {
            navigationBarLayout.apply(to: navigationBar)
        }
        
        navigationController?.setNavigationBarHidden(navigationBarLayout.navigationBarHidden, animated: animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: String.empty, style: .plain, target: nil, action: nil)
    }
    
    override open func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if let navigationController = parent as? UINavigationController {
            let count = navigationController.viewControllers.count
            if count > 1, let viewController = navigationController.viewControllers[count - 2] as? Layoutable {
                previousNavigationBarLayout = viewController.navigationBarLayout
            }
        }
    }
    
    override open func willMove(toParent parent: UIViewController?) { // tricky part in iOS 10
        if let navigationBar = navigationController?.navigationBar {
            previousNavigationBarLayout?.apply(to: navigationBar)
        }
        
        super.willMove(toParent: parent)
    }
    
    override open var prefersStatusBarHidden: Bool {
        return navigationBarLayout.statusBarHidden
    }
    
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return navigationBarLayout.statusBarStyle
    }
}

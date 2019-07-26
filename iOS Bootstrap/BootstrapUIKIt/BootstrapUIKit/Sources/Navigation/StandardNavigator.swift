//
//  StandardNavigator.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation
import BootstrapShared
import SafariServices

public final class StandardNavigator: NSObject {
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private var mainCoordinator: MainCoordinable?
    private var currentTransition: UIViewControllerAnimatedTransitioning?

    override public init() {
        super.init()
        FontWeight.loadAllFonts()
    }
}

extension StandardNavigator: Navigator {
   
    // MARK: Main
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
            dismiss()
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

    // MARK: Presentation & navigation
    public func present(viewController: UIViewController, presentationStyle: UIModalPresentationStyle) {
        viewController.modalPresentationStyle = presentationStyle
        window.rootViewController?.present(viewController, animated: true)
    }
    
    public func navigate(to coordinator: Coordinator) {
        navigate(to: coordinator, presenter: Presenter())
    }
    
    public func navigate(to coordinator: Coordinator, presenter: Presenter) {
        go(to: coordinator.start(), presenter: presenter)
    }
    
    // MARK: Safari
    public func open(url: String) {
        guard let url = URL(string: url) else { return }
        let safariViewController = SFSafariViewController(url: url)
        self.present(viewController: safariViewController)
    }
    
    public func safari(url: String) {
        guard let url = URL(string: url) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    // MARK: Close
    @objc
    private func close() {
        dismiss()
    }
    
    public func dismiss() {
        dismiss {}
    }
    
    public func dismissToRoot(completion: @escaping () -> Void) {
        dismiss(toRoot: true, completion: completion)
    }
    
    public func dismiss(completion: @escaping () -> Void) {
        dismiss(toRoot: false, completion: completion)
    }
    
    public func dismiss(toRoot: Bool = false, completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.dismiss(toRoot: toRoot, completion: completion)
            }
            
            return
        }
        
        guard let viewController = currentRootViewController else { return }
        
        // VC sta presentando un figlio
        if viewController.presentedViewController != nil {
            viewController.presentedViewController?.dismiss(animated: true, completion: completion)
            return
        }
        
        // VC
        let children = viewController.leafViewController?.children.map { $0 as? Childable }.compactMap { $0 }.filter { $0.isChild }
        if let children = children {
            if let child = children.last as? UIViewController {
                removeChild(viewController: child)
                completion()
                return
            }
        }
        
        // VC è presentato da un padre
        if viewController.presentingViewController != nil {
            viewController.dismiss(animated: true, completion: completion)
            return
        }
        
        // VC è una navigation controller con più di un vc nello stack.
        if let nvc = viewController as? UINavigationController {
            if nvc.viewControllers.count > 1 {
                DispatchQueue.main.async {
                    if toRoot {
                        CATransaction.begin()
                        CATransaction.setCompletionBlock {
                            completion()
                        }
                        nvc.popToRootViewController(animated: true)
                        CATransaction.commit()
                        
                    } else {
                        nvc.popViewController(animated: true, completion: completion)
                    }
                    return
                }
            } else {
                completion()
                return
            }
        }
    }
}

// MARK: - Private Methods
private extension StandardNavigator {
    func go(to viewController: UIViewController, presenter: Presenter) {
        DispatchQueue.main.async {
            if let lvc = viewController as? Layoutable, let navigationBarLayout = presenter.navigationBarLayout {
                lvc.navigationBarLayout = navigationBarLayout
            }
            
            switch presenter.mode {
            case .fullscreen:
                self.handleStandard(viewController: viewController, presenter: presenter, isFullScreen: true)
            case .standard:
                self.handleStandard(viewController: viewController, presenter: presenter, isFullScreen: false)
            case .modal(let configuration):
                self.handleModal(viewController: viewController, presenter: presenter, configuration: configuration)
            case .overlay:
                self.handleOverlay(viewController: viewController, presenter: presenter)
            case .content(frame: let frame):
                self.handleContent(viewController: viewController, presenter: presenter, frame: frame)
            }
        }
    }
}

private extension StandardNavigator {
    func removeChild(viewController: UIViewController) {
        guard viewController.parent != nil else { return }
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.view.removeFromSuperview()
    }
    
    var currentRootViewController: UIViewController? {
        if let tbc = window.rootViewController as? UITabBarController {
            if let selected = tbc.selectedViewController {
                return findFinalPresented(from: selected)
            }
        }
        
        if let nvc = window.rootViewController as? UINavigationController {
            return findFinalPresented(from: nvc)
        }
        
        return window.rootViewController
    }
    
    func findFinalPresented(from viewController: UIViewController) -> UIViewController {
        if let presented = viewController.presentedViewController, !(presented is SFSafariViewController) {
            return findFinalPresented(from: presented)
        }
        
        return viewController
    }
    
    func handleStandard(viewController: UIViewController, presenter: Presenter, isFullScreen: Bool) {
        guard let navController = self.currentRootViewController as? UINavigationController else {
            self.currentRootViewController?.present(viewController, animated: true)
            return
        }
        
        self.currentTransition = presenter.transitioning
        
        if presenter.transitioning != nil {
            navController.delegate = nil
            navController.delegate = self
        }
        
        if isFullScreen {
            viewController.hidesBottomBarWhenPushed = true
            
            // Manage left button
            if case .fullscreen(let configuration) = presenter.mode {
                let leftButton = UIButton(type: .custom)
                
                switch configuration.leftButton {
                case .none:
                    // no customization
                    break
                case .close:
                    leftButton.setTitle("Close", for: .normal)
                    viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
                case .backArrow:
                    leftButton.setImage(UIImage.uiKit(named: "button_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
                }
            }
        }
        
        navController.pushViewController(viewController, animated: true)
    }
    
    func handleModal(viewController: UIViewController, presenter: Presenter, configuration: PresenterModalConfiguration) {
        guard var current = self.currentRootViewController else { return }
        var toDismiss: UIViewController?
        var theViewController = viewController
        
        // Current è presentato da un vc padre. In questo caso
        // fa il dismiss di current e prende il vc padre come
        // punto di partenza per mostrare il nuovo view controller.
        if presenter.isPreviousDismissEnabled, let presenting = current.presentingViewController {
            toDismiss = current
            current = presenting
        }
        
        if presenter.transition == .fade {
            self.currentRootViewController?.modalTransitionStyle = .crossDissolve
            theViewController.modalTransitionStyle = .crossDissolve
        }
        
        if configuration.isEmbeddedInNavigation {
            theViewController = viewController.embeddedInNav()
        }
        
        switch configuration.leftButton {
        case .none:
            break
        case .close:
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.close))
        case .back:
            let backButton = UIButton(type: .custom)
            backButton.setImage(UIImage.uiKit(named: "button_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
            backButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
        
        toDismiss?.dismiss(animated: false)
        current.present(theViewController, animated: true)
    }
    
    func handleOverlay(viewController: UIViewController, presenter: Presenter) {
        guard var current = self.currentRootViewController else { return }
        var toDismiss: UIViewController?
        
        // Current è presentato da un vc padre. In questo caso
        // fa il dismiss di current e prende il vc padre come
        // punto di partenza per mostrare il nuovo view controller.
        if presenter.isPreviousDismissEnabled, let presenting = current.presentingViewController {
            toDismiss = current
            current = presenting
        }
        
        let theViewController = viewController.embeddedInNav()
        theViewController.modalPresentationStyle = .overFullScreen
        theViewController.modalTransitionStyle = .crossDissolve
        theViewController.modalPresentationCapturesStatusBarAppearance = true
        
        toDismiss?.dismiss(animated: false)
        current.present(theViewController, animated: true)
    }
    
    func handleContent(viewController: UIViewController, presenter: Presenter, frame: CGRect) {
        guard let current = self.currentRootViewController?.leafViewController else { return }
        if let child = viewController as? Childable { child.isChild = true }
        
        current.addChild(viewController)
        current.view.addSubview(viewController.view)
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        let width = viewController.view.widthAnchor.constraint(equalToConstant: frame.width)
        let height = viewController.view.heightAnchor.constraint(equalToConstant: frame.height)
        let top = viewController.view.topAnchor.constraint(equalTo: current.view.topAnchor, constant: frame.origin.y)
        let leading = viewController.view.leadingAnchor.constraint(equalTo: current.view.leadingAnchor, constant: frame.origin.x)
        
        width.identifier = UIKitConstants.Constraint.ChildWidthIdentifier
        height.identifier = UIKitConstants.Constraint.ChildHeightIdentifier
        top.identifier = UIKitConstants.Constraint.ChildTopIdentifier
        leading.identifier = UIKitConstants.Constraint.ChildLeadingIdentifier
        
        NSLayoutConstraint.activate([width, height, top, leading])
        viewController.didMove(toParent: current)
    }
}

extension StandardNavigator: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationController.Operation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return currentTransition
    }
}

public enum UIKitConstants {
    public enum Constraint {
        public static let ChildWidthIdentifier = "ChildWidthConstraintIdentifier"
        public static let ChildHeightIdentifier = "ChildHeightConstraintIdentifier"
        public static let ChildTopIdentifier = "ChildTopConstraintIdentifier"
        public static let ChildLeadingIdentifier = "ChildLeadingConstraintIdentifier"
    }
}

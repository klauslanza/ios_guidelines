//
//  FadeTransition.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 26/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public final class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning {
    var isPresenting: Bool
    
    public init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        fromViewController.view.frame = transitionContext.containerView.bounds
        toViewController.view.frame = transitionContext.containerView.bounds
        
        if toViewController.isBeingPresented {
            fromViewController.view.isUserInteractionEnabled = false
            toViewController.view.alpha = 0.0
            
            transitionContext.containerView.addSubview(toViewController.view)
            
            // Start appearance transition for source controller
            // Because UIKit does not do this automatically.
            fromViewController.beginAppearanceTransition(false, animated: true)
            
            let duration = transitionDuration(using: transitionContext)
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: [.curveEaseInOut], animations: {
                toViewController.view.alpha = 1.0
            }, completion: { _ in
                fromViewController.endAppearanceTransition()
                transitionContext.completeTransition(true)
            })
        } else {
            toViewController.view.isUserInteractionEnabled = true
            transitionContext.containerView.bringSubviewToFront(toViewController.view)
            
            // Start appearance transition for destination controller
            // Because UIKit does not do this automatically
            toViewController.beginAppearanceTransition(true, animated: true)
            
            let duration = transitionDuration(using: transitionContext)
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: [.curveEaseInOut], animations: {
                fromViewController.view.alpha = 0.0
            }, completion: { _ in
                toViewController.endAppearanceTransition()
                transitionContext.completeTransition(true)
            })
        }
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        fromViewController.view.frame = transitionContext.containerView.bounds
        toViewController.view.frame = transitionContext.containerView.bounds
        
        //        if toViewController.isBeingPresented {
        fromViewController.view.isUserInteractionEnabled = false
        toViewController.view.alpha = 0.0
        
        transitionContext.containerView.addSubview(toViewController.view)
        
        // Start appearance transition for source controller
        // Because UIKit does not do this automatically.
        fromViewController.beginAppearanceTransition(false, animated: true)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: [.curveEaseInOut], animations: {
            toViewController.view.alpha = 1.0
        }, completion: { _ in
            fromViewController.endAppearanceTransition()
            transitionContext.completeTransition(true)
        })
    }
}

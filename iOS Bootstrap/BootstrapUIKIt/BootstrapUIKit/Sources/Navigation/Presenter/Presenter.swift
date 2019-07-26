//
//  Presenter.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 26/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public enum PresenterMode {
    case standard
    case modal(config: PresenterModalConfiguration)
    case overlay
    case fullscreen(config: PresenterFullscreenConfiguration)
    case content(frame: CGRect)
}

public enum PresenterTransition {
    case standard
    case fade
}

public struct Presenter {
    public let mode: PresenterMode
    public let transition: PresenterTransition
    public let navigationBarLayout: NavigationBarLayout?
    public let isPreviousDismissEnabled: Bool
    
    internal var transitioning: UIViewControllerAnimatedTransitioning? {
        switch transition {
        case .standard:
            return nil
        case .fade:
            return FadeTransition(isPresenting: false)
        }
    }
    
    public init(mode: PresenterMode = .standard, navigationBarLayout: NavigationBarLayout? = nil, transition: PresenterTransition = .standard, isPreviousDismissEnabled: Bool = false) {
        self.mode = mode
        self.transition = transition
        self.navigationBarLayout = navigationBarLayout
        self.isPreviousDismissEnabled = isPreviousDismissEnabled
    }
}

public extension Presenter {
    static let interstitial = Presenter(mode: PresenterMode.fullscreen(config: PresenterFullscreenConfiguration()), navigationBarLayout: NavigationBarLayout.hidden, transition: PresenterTransition.standard, isPreviousDismissEnabled: true)
}

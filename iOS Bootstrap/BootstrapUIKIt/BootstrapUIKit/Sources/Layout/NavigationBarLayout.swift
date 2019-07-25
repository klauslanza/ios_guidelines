//
//  NavigationBarLayout.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public struct NavigationBarLayout {    
    public let tintColor: UIColor?
    public let barTintColor: UIColor?
    public let titleTextColor: UIColor?
    public let titleTextFont: UIFont?
    public let isTranslucent: Bool?
    public let backgroundImage: UIImage?
    public let shadowImage: UIImage?
    public let navigationBarHidden: Bool
    public let statusBarStyle: UIStatusBarStyle
    public let statusBarHidden: Bool
    public let shadowReset: Bool
    
    public init(tintColor: UIColor? = nil,
                barTintColor: UIColor? = nil,
                titleTextColor: UIColor? = nil,
                titleTextFont: UIFont? = nil,
                isTranslucent: Bool? = nil,
                backgroundImage: UIImage? = nil,
                shadowImage: UIImage? = nil,
                navigationBarHidden: Bool = false,
                statusBarStyle: UIStatusBarStyle = .default,
                statusBarHidden: Bool = false,
                shadowReset: Bool = false) {
        self.tintColor = tintColor
        self.barTintColor = barTintColor
        self.titleTextColor = titleTextColor
        self.titleTextFont = titleTextFont
        self.isTranslucent = isTranslucent
        self.backgroundImage = backgroundImage
        self.shadowImage = shadowImage
        self.navigationBarHidden = navigationBarHidden
        self.statusBarStyle = statusBarStyle
        self.statusBarHidden = statusBarHidden
        self.shadowReset = shadowReset
    }
    
    public func apply(to bar: UINavigationBar) {
        if let image = backgroundImage {
            bar.setBackgroundImage(image, for: .any, barMetrics: .default)
        }
        
        if let image = shadowImage {
            bar.shadowImage = image
        }
        
        if shadowReset {
            bar.shadowImage = nil
            bar.setBackgroundImage(nil, for: .any, barMetrics: .default)
        }
        
        if let titleColor = titleTextColor, let font = titleTextFont {
            var attributes = bar.titleTextAttributes ?? [NSAttributedString.Key: Any]()
            attributes[NSAttributedString.Key.foregroundColor] = titleColor
            attributes[NSAttributedString.Key.font] = font
            bar.titleTextAttributes = attributes
            
            if #available(iOS 11.0, *) {
                bar.largeTitleTextAttributes = attributes
            }
        }
        
        if let translucent = isTranslucent {
            bar.isTranslucent = translucent
        }
        
        if let color = tintColor {
            bar.tintColor = color
        }
        
        if let color = barTintColor {
            bar.barTintColor = color
        }
    }
}

public extension NavigationBarLayout {
    
    static var base: NavigationBarLayout {
        return NavigationBarLayout(tintColor: .white,
                                   barTintColor: .white,
                                   titleTextColor: .white,
                                   titleTextFont: FontLayout.font(rel: 1.2, weight: .regular),
                                   isTranslucent: false,
                                   backgroundImage: UIImage(named: "navigation_bar_background", in: Bundle.uiKitBundle, compatibleWith: nil),
                                   shadowImage: UIImage(),
                                   statusBarStyle: .lightContent)
    }
    
    static let hidden = NavigationBarLayout(isTranslucent: false,
                                            navigationBarHidden: true,
                                            statusBarStyle: .lightContent,
                                            statusBarHidden: true)
    
    static let hiddenStatusBar = NavigationBarLayout(isTranslucent: false,
                                                     navigationBarHidden: true,
                                                     statusBarStyle: .lightContent,
                                                     statusBarHidden: false)
}

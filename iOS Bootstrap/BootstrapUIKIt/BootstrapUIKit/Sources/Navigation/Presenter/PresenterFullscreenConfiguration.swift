//
//  PresenterFullscreenConfiguration.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 26/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation
public struct PresenterFullscreenConfiguration {
    public typealias Action = () -> Void

    public enum LeftButton {
        case none
        case close
        case backArrow
    }
    
    public let leftButton: LeftButton
    public let action: Action?
    
    public init(leftButton: LeftButton = .none, action: Action? = nil) {
        self.leftButton = leftButton
        self.action = action
    }
}

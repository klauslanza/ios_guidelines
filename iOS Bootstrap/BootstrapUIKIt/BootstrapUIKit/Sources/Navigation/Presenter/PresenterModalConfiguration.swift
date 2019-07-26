//
//  PresenterModalConfiguration.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 26/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public struct PresenterModalConfiguration {
    public enum LeftButton {
        case none
        case close
        case back
    }
    
    public let isEmbeddedInNavigation: Bool
    public let leftButton: LeftButton
    
    public init(isEmbeddedInNavigation: Bool = true, leftButton: LeftButton = .close) {
        self.isEmbeddedInNavigation = isEmbeddedInNavigation
        self.leftButton = leftButton
    }
}

public extension PresenterModalConfiguration {
    static let standard = PresenterModalConfiguration(isEmbeddedInNavigation: true, leftButton: .close)
    static let standardBack = PresenterModalConfiguration(isEmbeddedInNavigation: true, leftButton: .back)
    static let standardNoButton = PresenterModalConfiguration(isEmbeddedInNavigation: true, leftButton: .none)
    static let noNavigation = PresenterModalConfiguration(isEmbeddedInNavigation: false, leftButton: .none)
}

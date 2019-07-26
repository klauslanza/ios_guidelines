//
//  UIImage.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 26/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public extension UIImage {
    static func uiKit(named: String) -> UIImage? {
        return UIImage(named: named, in: Bundle.uiKitBundle, compatibleWith: nil)
    }
}

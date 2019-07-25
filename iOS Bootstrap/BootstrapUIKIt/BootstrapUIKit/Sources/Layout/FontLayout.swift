//
//  FontLayout.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public enum FontWeight: String, CaseIterable {
    case light = "Montserrat-Light"
    case regular = "Montserrat-Regular"
    case semibold = "Montserrat-SemiBold"
    case medium = "Montserrat-Medium"
    case bold = "Montserrat-Bold"
}

public extension FontWeight {
    static func loadAllFonts() {
        let styles = allCases.map { $0.rawValue }
        
        styles.forEach { styleString in
            guard let fontUrl = Bundle(for: StandardNavigator.self).url(forResource: styleString, withExtension: "ttf") else { return }
            guard let fontData = try? Data(contentsOf: fontUrl) else { return }
            guard let fontProvider = CGDataProvider(data: fontData as CFData) else { return }
            guard let fontRef = CGFont(fontProvider) else { return }
            var errorFont: Unmanaged<CFError>?
            if CTFontManagerRegisterGraphicsFont(fontRef, &errorFont) {
                print("Font loaded: \(styleString), error: \(errorFont.debugDescription)")
            }
        }
    }
}

public enum FontLayout {
    private static var fontSizeBaseUnit: CGFloat {
        let width = UIScreen.main.bounds.width
        let size: CGFloat = width >= 360 ? 15 : 13
        return size
    }
    
    public static func font(size: CGFloat, weight: FontWeight = .regular) -> UIFont {
        let font = UIFont(name: weight.rawValue, size: size)
        if let current = font {
            return current
        }
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    public static func font(rel: Float, weight: FontWeight = .regular) -> UIFont {
        let size = fontSizeBaseUnit * CGFloat(rel)
        return font(size: size, weight: weight)
    }
}

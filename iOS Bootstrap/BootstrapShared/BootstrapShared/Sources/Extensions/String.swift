//
//  String.swift
//  BootstrapShared
//
//  Created by Klaus Lanzarini on 05/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public extension String {
    static let empty = ""
    static let space = " "
    
    func matches(for regex: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: regex)
        if let regex = regex,
            !regex.matches(in: self, range: NSRange(self.startIndex..., in: self)).isEmpty {
            return true
        }
        
        return false
    }
}

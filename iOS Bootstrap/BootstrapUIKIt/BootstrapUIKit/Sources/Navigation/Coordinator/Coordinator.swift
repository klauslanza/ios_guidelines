//
//  Coordinator.swift
//  BootstrapUIKit
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public protocol Coordinator: class {
    func start() -> UIViewController
}

public protocol MainCoordinable: class {
    func set(root: Coordinator)
    func set(root: Coordinator, animated: Bool)
}

public extension MainCoordinable {
    func set(root: Coordinator) {
        set(root: root, animated: false)
    }
}

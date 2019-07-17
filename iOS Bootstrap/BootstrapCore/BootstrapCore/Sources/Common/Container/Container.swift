//
//  Container.swift
//  BootstrapCore
//
//  Created by Klaus Lanzarini on 05/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public enum ContainerError: Swift.Error {
    case componentNotFound
    case cantCreateComponent
}

public protocol Container: AnyObject {
    typealias Factory<T> = (Container) throws -> T
    
    func register<T>(key: String, instance: T)
    func register<T>(key: String, factory: @escaping Factory<T>)
    
    func register<T>(type: T.Type, instance: T)
    func register<T>(type: T.Type, factory: @escaping Factory<T>)
    
    func resolve<T>() throws -> T
    func resolve<T>(key: String) throws -> T
}

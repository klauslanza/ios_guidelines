//
//  ComponentContainer.swift
//  TemplateCore
//
//  Created by Klaus Lanzarini on 05/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public final class ComponentContainer {
    private var components: [String: Any] = [:]
    
    public init() {}
}

private extension ComponentContainer {
    func internalResolve<T>(for key: String) throws -> T {
        guard let component = components[key] else {
            throw ContainerError.componentNotFound
        }
        
        if let factory = component as? Factory<T> {
            return try factory(self)
        }
        
        guard let result = component as? T else {
            throw ContainerError.cantCreateComponent
        }
        
        return result
    }
}

extension ComponentContainer: Container {
    public func register<T>(type: T.Type, instance: T) {
        register(key: "\(type)", instance: instance)
    }
    
    public func register<T>(type: T.Type, factory: @escaping Factory<T>) {
        components["\(type)"] = factory
    }
    
    public func register<T>(key: String, instance: T) {
        components[key] = instance
    }
    
    public func register<T>(key: String, factory: @escaping (Container) throws -> T) {
        components[key] = factory
    }
    
    public func resolve<T>() throws -> T {
        return try resolve(key: "\(T.self)")
    }
    
    public func resolve<T>(key: String) throws -> T {
        return try internalResolve(for: key)
    }
}

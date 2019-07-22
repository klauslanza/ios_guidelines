//
//  RegistryService.swift
//  BootstrapCore
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation
import BootstrapShared

/// Defines the errors that the RegistryService can return.
///
public enum RegistryServiceError: Swift.Error {
    case noData
    case invalidData(key: CoreConstants.Registry)
    case decoding(error: DecodingError)
    case encoding(error: EncodingError)
}

/// Defines a generic protocol to handle a persistent Key-Value storage.
public protocol RegistryService {
    /// Saves a generic element, that conform to Codable protocol, in a registry key.
    ///
    /// - Parameters:
    ///   - element: The generic element to save.
    ///   - key: The key associated with the element to be save.
    /// - Throws: An error of type `RegistryServiceError`
    func save<T: Codable>(element: T, key: CoreConstants.Registry) throws
    
    /// Retrieves the element associated with the specified registry key.
    ///
    /// - Parameters:
    ///   - key: The key associated with the element to be find.
    /// - Returns: An instance of `T` type.
    /// - Throws: An error of type `RegistryServiceError`
    func get<T: Codable>(key: CoreConstants.Registry) throws -> T?
    
    /// Removes the element associated with the specified registry key.
    ///
    /// - Parameter
    ///   - key: The key associated with the element to be remove.
    /// - Throws: An error of type `RegistryServiceError`
    func remove(key: CoreConstants.Registry) throws
    
    /// Removes all elements in the registry.
    ///
    /// - Throws: An error of type `RegistryServiceError`
    func clear() throws
    
    /// Returns true if the given `key` exist in the registry.
    ///
    /// - Parameter key: The key associated with the element to check.
    func exist(key: CoreConstants.Registry) -> Bool
    
    /// Retrieves the element associated with the specified registry key and updates its value.
    ///
    /// - Parameters:
    ///   - key: The key associated with the element to be find.
    ///   - writer: The editing callback.
    /// - Throws: An error of type `RegistryServiceError`
    func write<T: Codable>(key: CoreConstants.Registry, writer: (inout T) -> Void) throws
}

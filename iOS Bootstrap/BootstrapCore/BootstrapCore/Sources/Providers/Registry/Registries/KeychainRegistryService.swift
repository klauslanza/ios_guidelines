//
//  KeychainRegistryService.swift
//  BootstrapCore
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation
import BootstrapShared
import KeychainAccess

final class KeychainRegistryService {
    private var keychain: Keychain
    
    init(service: String, accessGroup: String) {
        self.keychain = Keychain(service: service, accessGroup: accessGroup)
        self.keychain = keychain.accessibility(.afterFirstUnlock)
    }
}

// MARK: - RegistryService
extension KeychainRegistryService: RegistryService {
    func save<T: Codable>(element: T, key: CoreConstants.Registry) throws {
        do {
            let data = try JSONEncoder().encode(element)
            try keychain.set(data, key: key.rawValue)
        } catch let error as EncodingError {
            throw RegistryServiceError.encoding(error: error)
        } catch {
            throw RegistryServiceError.invalidData(key: key)
        }
    }
    
    func get<T: Codable>(key: CoreConstants.Registry) throws -> T? {
        guard let data = try keychain.getData(key.rawValue) else { return nil }
        
        do {
            let element = try JSONDecoder().decode(T.self, from: data)
            return element
        } catch let error as DecodingError {
            throw RegistryServiceError.decoding(error: error)
        } catch {
            throw RegistryServiceError.invalidData(key: key)
        }
    }
    
    func remove(key: CoreConstants.Registry) throws {
        do {
            try keychain.remove(key.rawValue)
        } catch {
            throw RegistryServiceError.invalidData(key: key)
        }
    }
    
    func clear() throws {
        do {
            try keychain.removeAll()
        } catch {
            throw RegistryServiceError.noData
        }
    }
    
    func exist(key: CoreConstants.Registry) -> Bool {
        do {
            let result = try keychain.getData(key.rawValue)
            return result != nil
        } catch {
            return false
        }
    }
    
    func write<T: Codable>(key: CoreConstants.Registry, writer: (inout T) -> Void) throws {
        guard var element: T = try get(key: key) else { return }
        writer(&element)
        try save(element: element, key: key)
    }
}

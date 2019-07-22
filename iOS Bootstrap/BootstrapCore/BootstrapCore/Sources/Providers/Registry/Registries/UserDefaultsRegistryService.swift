//
//  UserDefaultsRegistryService.swift
//  BootstrapCore
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation
import BootstrapShared

final class UserDefaultsRegistryService {
    private let userDefaults = UserDefaults.standard
}

// MARK: - RegistryService
extension UserDefaultsRegistryService: RegistryService {
    func save<T: Codable>(element: T, key: CoreConstants.Registry) throws {
        do {
            let data = try JSONEncoder().encode(element)
            userDefaults.set(data, forKey: key.rawValue)
        } catch let error as EncodingError {
            throw RegistryServiceError.encoding(error: error)
        } catch {
            throw RegistryServiceError.invalidData(key: key)
        }
    }
    
    func get<T: Codable>(key: CoreConstants.Registry) throws -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
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
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
    func clear() throws {
        UserDefaults.resetStandardUserDefaults()
    }
    
    func exist(key: CoreConstants.Registry) -> Bool {
        let exist = userDefaults.data(forKey: key.rawValue) != nil
        return exist
    }
    
    func write<T: Codable>(key: CoreConstants.Registry, writer: (inout T) -> Void) throws {
        guard var element: T = try get(key: key) else { return }
        writer(&element)
        try save(element: element, key: key)
    }
}

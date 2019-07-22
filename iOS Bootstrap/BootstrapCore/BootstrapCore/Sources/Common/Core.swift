//
//  Core.swift
//  BootstrapCore
//
//  Created by Klaus Lanzarini on 22/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

public final class Core {
    public let container: Container
    public let environment: Environment
    
    // MARK: Services
    public lazy var keychainService: RegistryService = KeychainRegistryService(service: "it.klauslanza.bootstrap", accessGroup: "XXXXXXXXXX.it.klauslanza.bootstrap.keychain")
    public lazy var userDefaultsService: RegistryService = UserDefaultsRegistryService()

    public init(container: Container, environment: Environment) {
        self.container = container
        self.environment = environment
        self.setupContainer()
    }
}

private extension Core {
    func setupContainer() {
        container.register(type: Environment.self, instance: environment)

        container.register(type: RegistryService.self) { [weak self] _ -> RegistryService in
            guard let self = self else { throw ContainerError.componentNotFound }
            return self.keychainService
        }
        
        container.register(key: CoreConstants.Components.UserDefaultsRegistry) { [weak self] _ -> RegistryService in
            guard let self = self else { throw ContainerError.componentNotFound }
            return self.userDefaultsService
        }
    }
}

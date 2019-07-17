//
//  Environment.swift
//  TemplateCore
//
//  Created by Klaus Lanzarini on 05/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation
import TemplateShared

public typealias EnvironmentHeaders = [String: String]

public struct Environment: Codable {
    
    public var name: String
    
    /// Base url of the environment.
    public var host: String
    
    /// The list of common headers which will be part of each Request
    /// Some headers value maybe overwritten by request's own headers.
    public var headers = EnvironmentHeaders()
    
    /// Static urls, free from the host
    public var webUrls: WebEnvironment
    
    /// Initializes a network environment.
    ///
    /// - Parameters:
    ///   - name: The environment name.
    ///   - host: The base host.
    ///   - headers: The list of common headers which will be part of each Request.
    public init(name: String, host: String, headers: EnvironmentHeaders = [:], webUrls: WebEnvironment) {
        self.name = name
        self.host = host
        self.headers = headers
        self.webUrls = webUrls
    }
}

public extension Environment {
    // MARK: Prod
    static let prod: Environment = {
        Environment(name: "prod",
                    host: "https://prod.test.com/api",
                    headers: Environment.commonHeaders,
                    webUrls: WebEnvironment.prod)
    }()
    
    // MARK: Stage
    static let stage: Environment = {
        Environment(name: "stage",
                    host: "https://stage.test.com/api",
                    headers: Environment.commonHeaders,
                    webUrls: WebEnvironment.stage)
    }()
}

private extension Environment {
    private static var commonHeaders: EnvironmentHeaders = {
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["accept-encoding"] = "gzip"
        headers["user-language"] = NSLocale.current.languageCode ?? String.empty
        return headers
    }()
}

//
//  CoreConstants.swift
//  TemplateCore
//
//  Created by Klaus Lanzarini on 05/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

/// Centralized location for all strings, anything hardcoded belongs here.
public enum CoreConstants {
    
    /// All endpoints used by the app, based on current environment
    enum Endpoint {
        // APP
        static let Config        = "/v1/app/config"

        // AUTH
        static let Login         = "/v1/authentication/login"
        static let LoginFacebook = "/v1/authentication/login-facebook"
        
        // USER
        static let profile       = "/v1/user/me"
    }
    
    /// Keys for keychain access
    public enum Registry {
        static let Credential  = "Bootstrap.Registry.Credential"
        static let User        = "Bootstrap.Registry.User"
    }
    
    /// Urls used in `WebEnvironment`
    enum WebUrls {
        // Site
        public static let SiteProd  = "https://prod.test.com/"
        public static let SiteStage = "https://stage.test.com/"
        // Faq
        public static let FaqProd  = "https://prod.test.com/faq"
        public static let FaqStage = "https://stage.test.com/faq"
    }
}

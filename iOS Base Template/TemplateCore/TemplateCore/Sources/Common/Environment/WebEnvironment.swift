//
//  WebEnvironment.swift
//  TemplateCore
//
//  Created by Klaus Lanzarini on 05/07/2019.
//  Copyright © 2019 Klaus Lanzarini. All rights reserved.
//

import Foundation

/// All urls not dependent from environment base host
public struct WebEnvironment: Codable {
    public let website: String
    public let faq: String
}

public extension WebEnvironment {
    static let prod: WebEnvironment = WebEnvironment(website: CoreConstants.WebUrls.SiteProd,
                                                     faq: CoreConstants.WebUrls.FaqProd)
    
    static let stage: WebEnvironment = WebEnvironment(website: CoreConstants.WebUrls.SiteStage,
                                                      faq: CoreConstants.WebUrls.FaqStage)
}

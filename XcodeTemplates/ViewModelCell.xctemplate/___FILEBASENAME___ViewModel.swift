//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

public final class ___FILEBASENAMEASIDENTIFIER___: AnyViewModel<___VARIABLE_SceneName___CollectionViewCell> {
    public var containerLayout: ContainerLayout {
        didSet {
            view?.configure(containerLayout: containerLayout)
        }
    }
    
    public init(containerLayout: ContainerLayout = .whiteStandard) {
        self.containerLayout = containerLayout
    }
        
    override public func configure() {
        view?.configure(containerLayout: containerLayout)
    }
}

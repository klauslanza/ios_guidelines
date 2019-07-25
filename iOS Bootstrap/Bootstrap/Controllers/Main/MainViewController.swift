//
//  MainViewController.swift
//  Bootstrap
//
//  Created by Klaus Lanzarini on 25/07/2019.
//  Copyright (c) 2019 Klaus Lanzarini. All rights reserved.
//

import UIKit
import BootstrapUIKit
import BootstrapDomain
import BootstrapShared

final class MainViewController: BaseViewController<MainViewControllerDelegate> {
    override func configure() {
        super.configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        configureSource()
    }
}

extension MainViewController {
    private func configureSource() {
    	
    }
}

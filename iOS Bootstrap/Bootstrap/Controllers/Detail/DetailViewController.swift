//
//  DetailViewController.swift
//  Bootstrap
//
//  Created by Klaus Lanzarini on 26/07/2019.
//  Copyright (c) 2019 Klaus Lanzarini. All rights reserved.
//

import UIKit
import BootstrapUIKit
import BootstrapDomain
import BootstrapShared

final class DetailViewController: BaseViewController<DetailViewControllerDelegate> {
    override func configure() {
        super.configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        configureView()
    }
}

extension DetailViewController {
    private func configureView() {
    	
    }
}

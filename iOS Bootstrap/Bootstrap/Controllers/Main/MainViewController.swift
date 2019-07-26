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
        view.backgroundColor = .lightGray
        configureView()
    }
}

private extension MainViewController {
    private func configureView() {
    	let button = UIButton(type: .custom)
        button.setTitle("DETAIL", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    }
    
    @objc
    func tappedButton() {
        coordinator.goToDetail()
    }
}

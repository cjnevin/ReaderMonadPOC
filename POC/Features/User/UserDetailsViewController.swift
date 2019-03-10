//
//  UserDetailsViewController.swift
//  POC
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import UIKit

class UserDetailsViewController: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func bind() {
        super.bind()
        subscribe(to: \.selectedUser) { [unowned self] user in
            self.navigationItem.title = user?.name
        }
    }
}

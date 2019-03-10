//
//  ViewController.swift
//  POC
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import UIKit
import Render

class UserListViewController: TableViewController {
    private let users = UserListDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        store.dispatch(.download(.start))
        users.tableView = tableView
        navigationItem.title = "Users"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addUser))
    }

    @objc func addUser() {
        store.dispatch(.users(.inject(.random())))
    }

    @objc override func bind() {
        super.bind()
        store.dispatch(.users(.watch))
        subscribe(to: \.latestUsers) { [unowned users] (latestUsers) in
            users.items = latestUsers
        }
    }
}

final class UserListDataSource: TableViewDataSource<User> { }

extension User: TableViewCellModel {
    func cell(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = name
        return cell
    }

    func didSelect(at indexPath: IndexPath, in tableView: UITableView) {
        store.dispatch(.users(.select(self)))
    }
}

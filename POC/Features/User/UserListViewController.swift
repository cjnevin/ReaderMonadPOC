//
//  ViewController.swift
//  POC
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import UIKit
import Render

class UserListViewController: UITableViewController {
    private let users = UserListDataSource()
    var injectTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        store.dispatch(.download(.start))
        users.tableView = tableView
        navigationItem.title = "Users"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.dispatch(.users(.watch))
        store.subscribe(.userList, to: \.latestUsers) { [unowned users] (latestUsers) in
            users.items = latestUsers
        }
        injectTimer = store.timed { AppAction.prism.users.inject.review(.random()) }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposal(for: .userList)().dispose()
        injectTimer?.invalidate()
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
}

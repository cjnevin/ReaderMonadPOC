//
//  ViewController.swift
//  POC
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import UIKit

class AbstractDataSource<T>: NSObject {
    var items: [T] = [] {
        didSet { reload() }
    }
    func reload() { }
}

final class UserListDataSource: AbstractDataSource<User>, UITableViewDataSource {
    weak var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
            reload()
        }
    }

    override func reload() {
        tableView?.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = items[indexPath.row].name
        return cell
    }
}


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
        store.subscribe(.root, to: \.latestUsers) { [unowned users] (latestUsers) in
            users.items = latestUsers
        }
        injectTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            store.dispatch(.users(.inject(.random())))
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposal(for: .root)().dispose()
        injectTimer?.invalidate()
    }
}

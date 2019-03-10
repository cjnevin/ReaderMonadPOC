//
//  TableViewDataSource.swift
//  Render
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import UIKit

public protocol TableViewCellModel {
    func cell(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
    func didSelect(at indexPath: IndexPath, in tableView: UITableView)
}

open class TableViewDataSource<T: TableViewCellModel>: AbstractDataSource<T>, UITableViewDataSource, UITableViewDelegate {
    open weak var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self
            reload()
        }
    }

    open override func reload() {
        tableView?.reloadData()
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return items[indexPath.row].cell(at: indexPath, in: tableView)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return items[indexPath.row].didSelect(at: indexPath, in: tableView)
    }
}

//
//  Disk.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public protocol Disk {
    func delete(from path: URL) -> Result<Void, DeleteError>
    func read(from path: URL) -> Result<Data, ReadError>
    func write(_ value: Data, to path: URL) -> Result<Void, WriteError>
}

// MARK: - Laws

extension Disk {
    /// Test same value is returned
    public func writeRead(data: Data, path: URL) -> Bool {
        guard case .success = write(data, to: path) else { return false }
        guard case .success(let match) = read(from: path) else { return false }
        return match == data
    }

    /// Test written value can be deleted
    public func writeDeleteRead(data: Data, path: URL) -> Bool {
        guard case .success = write(data, to: path) else { return false }
        guard case .success = delete(from: path) else { return false }
        guard case .failure = read(from: path) else { return false }
        return true
    }
}

//
//  DiskLogger.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public struct DiskLogger: Disk {
    public let disk: Disk

    public init(_ disk: Disk) {
        self.disk = disk
    }

    public func delete(from path: URL) -> Result<Void, DeleteError> {
        return log(disk.delete(from: path), path: path, prefix: "delete")
    }

    public func read(from path: URL) -> Result<Data, ReadError> {
        return log(disk.read(from: path), path: path, prefix: "read")
    }

    public func write(_ value: Data, to path: URL) -> Result<Void, WriteError> {
        return log(disk.write(value, to: path), path: path, prefix: "write")
    }

    private func log<T, E>(_ result: Result<T, E>, path: URL, prefix: String) -> Result<T, E> {
        print("[DiskLogger] \(prefix) \(path.lastPathComponent) - \(result)")
        return result
    }
}

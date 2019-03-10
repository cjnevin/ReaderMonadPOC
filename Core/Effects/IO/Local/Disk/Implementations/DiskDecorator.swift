//
//  DiskDecorator.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public class DiskDecorator: Disk {
    public let disk: Disk
    var decorator: ((String) -> Void)?

    public init(_ disk: Disk) {
        self.disk = disk
    }

    public func delete(from path: URL) -> Result<Void, DeleteError> {
        return decorate(disk.delete(from: path), path: path, prefix: "delete")
    }

    public func read(from path: URL) -> Result<Data, ReadError> {
        return decorate(disk.read(from: path), path: path, prefix: "read")
    }

    public func write(_ value: Data, to path: URL) -> Result<Void, WriteError> {
        return decorate(disk.write(value, to: path), path: path, prefix: "write")
    }

    private func decorate<T, E>(_ result: Result<T, E>, path: URL, prefix: String) -> Result<T, E> {
        decorator?("\(prefix) \(path.lastPathComponent) - \(result)")
        return result
    }
}


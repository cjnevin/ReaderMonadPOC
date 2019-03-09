//
//  DiskRecorder.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public class DiskRecorder: Disk, Recorder {
    public private(set) var events: [String] = []
    private let disk: Disk

    public init(_ disk: Disk) {
        self.disk = disk
    }

    public func delete(from path: URL) -> Result<Void, DeleteError> {
        return record(disk.delete(from: path), path: path, prefix: "delete")
    }

    public func read(from path: URL) -> Result<Data, ReadError> {
        return record(disk.read(from: path), path: path, prefix: "read")
    }

    public func write(_ value: Data, to path: URL) -> Result<Void, WriteError> {
        return record(disk.write(value, to: path), path: path, prefix: "write")
    }

    private func record<T, E>(_ result: Result<T, E>, path: URL, prefix: String) -> Result<T, E> {
        events.append("\(prefix) \(path.lastPathComponent) - \(result)")
        return result
    }
}

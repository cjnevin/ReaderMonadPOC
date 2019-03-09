//
//  Memory.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public final class MemoryDisk: Disk {
    private(set) var values: [URL: Data]

    public init(_ values: [URL: Data] = [:]) {
        self.values = values
    }

    public func delete(from path: URL) -> Result<Void, DeleteError> {
        return values.removeValue(forKey: path).map { _ in Result.success(()) } ?? Result.failure(.notDeletable)
    }

    public func read(from path: URL) -> Result<Data, ReadError> {
        return values[path].map(Result.success) ?? Result.failure(.notFound)
    }

    public func write(_ value: Data, to path: URL) -> Result<Void, WriteError> {
        values[path] = value
        return .success(())
    }
}

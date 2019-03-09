//
//  FileManager.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

extension FileManager: Disk {
    public func delete(from path: String) -> Result<Void, DeleteError> {
        return Try { try self.removeItem(atPath: path) }
            .result(DeleteError.notDeletable)
    }

    public func read(from path: String) -> Result<Data, ReadError> {
        return contents(atPath: path).map(Result.success) ?? Result.failure(.notFound)
    }

    public func write(_ value: Data, to path: String) -> Result<Void, WriteError> {
        return Try { try self.removeItem(atPath: path) }
            .map { self.createFile(atPath: path, contents: value, attributes: nil) }
            .flatMap { $0 ? .success(()) : .throw() }
            .result(WriteError.notWritable)
    }
}

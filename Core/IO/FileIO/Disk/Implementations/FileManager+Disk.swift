//
//  FileManager.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

extension FileManager: Disk {
    public func delete(from path: URL) -> Result<Void, DeleteError> {
        return Try { try self.removeItem(at: path) }
            .result(DeleteError.notDeletable)
    }

    public func read(from path: URL) -> Result<Data, ReadError> {
        return Try { try Data(contentsOf: path) }
            .result(ReadError.notFound)
    }

    public func write(_ value: Data, to path: URL) -> Result<Void, WriteError> {
        return Try { try value.write(to: path, options: .atomicWrite) }
            .result(WriteError.notWritable)
    }
}

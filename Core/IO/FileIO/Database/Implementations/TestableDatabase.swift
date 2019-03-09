//
//  TestableDatabase.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public final class TestableDatabase: Database {
    private let database: Database

    public init(_ database: Database) {
        self.database = database
    }

    public var readError: ReadError?
    public func read<T: DatabaseReadable>(id: String) -> Result<T, ReadError> {
        return readError.map(Result.failure) ?? database.read(id: id)
    }

    public var writeError: WriteError?
    public func write<T: DatabaseWritable>(_ value: T, for id: String) -> Result<Void, WriteError> {
        return writeError.map(Result.failure) ?? database.write(value, for: id)
    }
}

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

    public var objectsError: ReadError?
    public func objects<T: DatabaseObjectsObservable>(ofType type: T.Type) -> Signal<[T], ReadError> {
        return objectsError.map(Signal.error) ?? database.objects(ofType: type)
    }

    public var deleteError: DeleteError?
    public func delete<T: DatabaseDeletable>(id: String, ofType: T.Type) -> Result<Void, DeleteError> {
        return deleteError.map(Result.failure) ?? database.delete(id: id, ofType: ofType)
    }

    public var readError: ReadError?
    public func read<T: DatabaseReadable>(id: String, ofType: T.Type) -> Result<T, ReadError> {
        return readError.map(Result.failure) ?? database.read(id: id, ofType: ofType)
    }

    public var writeError: WriteError?
    public func write<T: DatabaseWritable>(_ value: T, for id: String) -> Result<Void, WriteError> {
        return writeError.map(Result.failure) ?? database.write(value, for: id)
    }
}

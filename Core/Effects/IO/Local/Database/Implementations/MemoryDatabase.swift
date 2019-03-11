//
//  MemoryDatabase.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public final class MemoryDatabase: Database {
    private(set) var values: [String: Any]

    public init(_ values: [String: Any] = [:]) {
        self.values = values
    }

    public func objects<T: DatabaseObjectsObservable>(for query: Query<T.DatabaseObject>) -> Result<[T], ReadError> {
        return .success(values.values.compactMap { $0 as? T })
    }

    public func recurringObjects<T: DatabaseObjectsObservable>(for query: Query<T.DatabaseObject>) -> Signal<[T], ReadError> {
        return .just(values.values.compactMap { $0 as? T })
    }

    public func delete<T: DatabaseDeletable>(id: String, ofType: T.Type) -> Result<Void, DeleteError> {
        if values.removeValue(forKey: id) != nil {
            return .success(())
        } else {
            return .failure(.notDeletable)
        }
    }

    public func read<T: DatabaseReadable>(id: String, ofType: T.Type) -> Result<T, ReadError> {
        return (values[id] as? T).map(Result.success) ?? Result.failure(.notFound)
    }
    
    public func write<T: DatabaseWritable>(_ value: T, for id: String) -> Result<Void, WriteError> {
        values[id] = value
        return .success(())
    }
}

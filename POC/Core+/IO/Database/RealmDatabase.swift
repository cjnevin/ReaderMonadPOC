//
//  RealmDatabase.swift
//  POC
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core
import RealmSwift

struct RealmDatabase: Database {
    func objects<T: DatabaseObjectsObservable>(for query: Query<T.DatabaseObject>) -> Result<[T], ReadError> {
        return T.objects(matching: query)
    }

    func recurringObjects<T: DatabaseObjectsObservable>(for query: Query<T.DatabaseObject>) -> Signal<[T], ReadError> {
        return T.recurringObjects(matching: query)
    }

    func delete<T: DatabaseDeletable>(id: String, ofType: T.Type) -> Result<Void, DeleteError> {
        guard ofType.canRead() else { return .failure(.notDeletable) }
        return ofType.delete(for: id) ? .success(()) : .failure(.notDeletable)
    }

    func read<T: DatabaseReadable>(id: String, ofType: T.Type) -> Result<T, ReadError> {
        guard ofType.canRead() else { return .failure(.notReadable) }
        return ofType.read(id: id).map(Result.success) ?? .failure(.notFound)
    }

    func write<T: DatabaseWritable>(_ value: T, for id: String) -> Result<Void, WriteError> {
        return value.write(for: id) ? Result.success(()) : .failure(.notWritable)
    }
}

//
//  DatabaseLogger.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public class DatabaseLogger: Database {
    public let database: Database
    private var disposables = CompositeDisposable([])

    public init(_ database: Database) {
        self.database = database
    }

    public func objects<T: DatabaseObjectsObservable>(ofType type: T.Type) -> Observable<[T], ReadError> {
        return log(database.objects(ofType: type), id: "\(type)", prefix: "all")
    }

    public func delete<T: DatabaseDeletable>(id: String, ofType: T.Type) -> Result<Void, DeleteError> {
        return log(database.delete(id: id, ofType: ofType), id: id, prefix: "delete \(ofType)")
    }

    public func read<T: DatabaseReadable>(id: String, ofType: T.Type) -> Result<T, ReadError> {
        return log(database.read(id: id, ofType: ofType), id: id, prefix: "read \(ofType)")
    }

    public func write<T: DatabaseWritable>(_ value: T, for id: String) -> Result<Void, WriteError> {
        return log(database.write(value, for: id), id: id, prefix: "write \(type(of: value))")
    }

    private func log<T, E>(_ result: Result<T, E>, id: String, prefix: String) -> Result<T, E> {
        print("[DatabaseLogger] \(prefix) \(id) - \(result)")
        return result
    }

    private func log<T, E>(_ result: Observable<T, E>, id: String, prefix: String) -> Observable<T, E> {
        disposables += result.subscribe { result in
            print("[DatabaseLogger] \(prefix) \(id) - \(result)")
        }
        return result
    }
}

//
//  DatabaseDecorator.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public class DatabaseDecorator: Database {
    private var disposables = CompositeDisposable([])
    public let database: Database
    var decorator: ((String) -> Void)?

    public init(_ database: Database) {
        self.database = database
    }

    public func objects<T: DatabaseObjectsObservable>(for query: DatabaseQuery<T.DatabaseObject>) -> Result<[T], ReadError> {
        return decorate(database.objects(for: query), id: "\(T.self)", prefix: "all")
    }

    public func recurringObjects<T: DatabaseObjectsObservable>(for query: DatabaseQuery<T.DatabaseObject>) -> Signal<[T], ReadError> {
        return decorate(database.recurringObjects(for: query), id: "\(T.self)", prefix: "all")
    }

    public func delete<T: DatabaseDeletable>(id: String, ofType: T.Type) -> Result<Void, DeleteError> {
        return decorate(database.delete(id: id, ofType: ofType), id: id, prefix: "delete \(ofType)")
    }

    public func read<T: DatabaseReadable>(id: String, ofType: T.Type) -> Result<T, ReadError> {
        return decorate(database.read(id: id, ofType: ofType), id: id, prefix: "read \(ofType)")
    }

    public func write<T: DatabaseWritable>(_ value: T, for id: String) -> Result<Void, WriteError> {
        return decorate(database.write(value, for: id), id: id, prefix: "write \(type(of: value))")
    }

    private func decorate<T, E>(_ result: Result<T, E>, id: String, prefix: String) -> Result<T, E> {
        decorator?("\(prefix) \(id) - \(result)")
        return result
    }

    private func decorate<T, E>(_ result: Signal<T, E>, id: String, prefix: String) -> Signal<T, E> {
        disposables += result.subscribe { [unowned self] result in
            self.decorator?("\(prefix) \(id) - \(result)")
        }
        return result
    }
}


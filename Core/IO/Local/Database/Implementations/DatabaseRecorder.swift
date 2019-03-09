//
//  DatabaseRecorder.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public class DatabaseRecorder: Database, Recorder {
    public private(set) var events: [String] = []
    private let database: Database
    private var disposables = CompositeDisposable([])

    public init(_ database: Database) {
        self.database = database
    }

    public func objects<T: DatabaseObjectsObservable>(ofType type: T.Type) -> Observable<[T], ReadError> {
        return record(database.objects(ofType: type), id: "\(type)", prefix: "all")
    }

    public func delete<T: DatabaseDeletable>(id: String, ofType: T.Type) -> Result<Void, DeleteError> {
        return record(database.delete(id: id, ofType: ofType), id: id, prefix: "delete \(ofType)")
    }

    public func read<T: DatabaseReadable>(id: String, ofType: T.Type) -> Result<T, ReadError> {
        return record(database.read(id: id, ofType: ofType), id: id, prefix: "read \(ofType)")
    }

    public func write<T: DatabaseWritable>(_ value: T, for id: String) -> Result<Void, WriteError> {
        return record(database.write(value, for: id), id: id, prefix: "write \(type(of: value))")
    }

    private func record<T, E>(_ result: Result<T, E>, id: String, prefix: String) -> Result<T, E> {
        events.append("\(prefix) \(id) - \(result)")
        return result
    }

    private func record<T, E>(_ result: Observable<T, E>, id: String, prefix: String) -> Observable<T, E> {
        disposables += result.subscribe { result in
            self.events.append("\(prefix) \(id) - \(result)")
        }
        return result
    }
}

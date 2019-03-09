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

    public init(_ database: Database) {
        self.database = database
    }

    public func read<T: DatabaseReadable>(id: String, ofType: T.Type) -> Result<T, ReadError> {
        return record(database.read(id: id, ofType: ofType), id: id, prefix: "read")
    }

    public func write<T: DatabaseWritable>(_ value: T, for id: String) -> Result<Void, WriteError> {
        return record(database.write(value, for: id), id: id, prefix: "write")
    }

    private func record<T, E>(_ result: Result<T, E>, id: String, prefix: String) -> Result<T, E> {
        events.append("\(prefix) \(id) - \(result)")
        return result
    }
}

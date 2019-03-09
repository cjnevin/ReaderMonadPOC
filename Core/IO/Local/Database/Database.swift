//
//  Database.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public protocol Database {
    func objects<T: DatabaseObjectsObservable>(ofType type: T.Type) -> Observable<[T], ReadError>
    func delete<T: DatabaseDeletable>(id: String, ofType: T.Type) -> Result<Void, DeleteError>
    func read<T: DatabaseReadable>(id: String, ofType: T.Type) -> Result<T, ReadError>
    func write<T: DatabaseWritable>(_ value: T, for id: String) -> Result<Void, WriteError>
}

public protocol DatabaseObjectsObservable: DatabaseReadable {
    static func objects() -> Observable<[Self], ReadError>
}

public protocol DatabaseReadable {
    static func canRead() -> Bool
    static func read(id: String) -> Self?
}

public protocol DatabaseWritable {
    func write(for id: String) -> Bool
}

public protocol DatabaseDeletable: DatabaseReadable {
    static func delete(for id: String) -> Bool
}

// MARK: Laws

extension Database {
    /// Test same value is returned
    public func writeRead<T: DatabaseReadable & DatabaseWritable & Equatable>(_ value: T, for id: String) -> Bool {
        guard case .success = write(value, for: id) else { return false }
        guard case .success(let match) = read(id: id, ofType: T.self) else { return false }
        return match == value
    }

    /// Test written value can be deleted
    public func writeDeleteRead<T: DatabaseDeletable & DatabaseReadable & DatabaseWritable>(value: T, for id: String) -> Bool {
        guard case .success = write(value, for: id) else { return false }
        guard case .success = delete(id: id, ofType: T.self) else { return false }
        guard case .failure = read(id: id, ofType: T.self) else { return false }
        return true
    }
}

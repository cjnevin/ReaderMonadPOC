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
    func read<T: DatabaseReadable>(id: String) -> Result<T, ReadError> {
        return T.read(id: id).map(Result.success) ?? Result.failure(.notFound)
    }

    func write<T: DatabaseWritable>(_ value: T, for id: String) -> Result<Void, WriteError> {
        return value.write(for: id) ? Result.success(()) : Result.failure(.notWritable)
    }
}

private let realmURL = URL(for: .documentDirectory, "POC.realm")
private let realmConfig = Realm.Configuration(fileURL: realmURL, schemaVersion: 1, objectTypes: [UserObject.self])

private func realm() -> Realm? {
    return try? Realm(configuration: realmConfig)
}

private func realmRead<T: Object>(type: T.Type, id: String) -> T? {
    return realm().flatMap { $0.object(ofType: T.self, forPrimaryKey: id) }
}

private func realmWrite<T: Object>(_ object: T) -> Bool {
    guard let db = realm() else { return false }
    return Try {
        try db.write {
            db.add(object, update: true)
        }
    }.error == nil
}

extension User: DatabaseReadable, DatabaseWritable {
    static func read(id: String) -> User? {
        return realmRead(type: UserObject.self, id: id)?.asModel()
    }

    func write(for id: String) -> Bool {
        return realmWrite(asDatabaseObject())
    }
}

private extension URL {
    init(for directory: FileManager.SearchPathDirectory, _ pathComponent: String = "") {
        guard let url = FileManager.default.urls(for: directory, in: .userDomainMask).first else { fatalError() }
        self = pathComponent.isEmpty ? url : url.appendingPathComponent(pathComponent)
    }
}

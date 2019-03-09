//
//  Database+World.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core

public func queryDatabase<T: DatabaseReadable>(id: String) -> WorldReader<WorldResult<T>> {
    return .init { world in
        world.database.read(id: id, ofType: T.self)
            .catch(WorldError.prism.database.read.review)
    }
}

public func writeToDatabase<T: DatabaseWritable>(_ value: T, for id: String) -> WorldReader<WorldResult<T>> {
    return .init { world in
        world.database.write(value, for: id)
            .catch(WorldError.prism.database.write.review)
            .replace(value)
    }
}

public func databaseObjects<T: DatabaseObjectsObservable>(ofType type: T.Type) -> WorldReader<WorldObservable<[T]>> {
    return .init { world in
        world.database.objects(ofType: type)
            .mapError(WorldError.prism.database.read.review)
    }
}

//
//  Database+World.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func queryDatabase<T: DatabaseReadable>(id: String) -> WorldIOResult<T> {
    return .init { world in
        world.database.read(id: id).mapError { WorldError.database(.read($0)) }
    }
}

public func writeToDatabase<T: DatabaseWritable>(_ value: T, for id: String) -> WorldIOResult<T> {
    return .init { world in
        world.database.write(value, for: id)
            .mapError { WorldError.database(.write($0)) }
            .map { _ in value }
    }
}

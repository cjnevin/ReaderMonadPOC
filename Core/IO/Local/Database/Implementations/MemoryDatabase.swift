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

    public func read<T: DatabaseReadable>(id: String, ofType: T.Type) -> Result<T, ReadError> {
        return (values[id] as? T).map(Result.success) ?? Result.failure(.notFound)
    }
    
    public func write<T: DatabaseWritable>(_ value: T, for id: String) -> Result<Void, WriteError> {
        values[id] = value
        return .success(())
    }
}

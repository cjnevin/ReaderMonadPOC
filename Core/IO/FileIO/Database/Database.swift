//
//  Database.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public protocol Database {
    func read<T: DatabaseReadable>(id: String) -> Result<T, ReadError>
    func write<T: DatabaseWritable>(_ value: T, for id: String) -> Result<Void, WriteError>
}

public protocol DatabaseReadable {
    static func read(id: String) -> Self?
}

public protocol DatabaseWritable {
    func write(for id: String) -> Bool
}

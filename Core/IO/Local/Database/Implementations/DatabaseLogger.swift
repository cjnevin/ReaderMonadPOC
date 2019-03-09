//
//  DatabaseLogger.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public class DatabaseLogger: DatabaseDecorator {
    public override init(_ database: Database) {
        super.init(database)
        decorator = { print("[DatabaseLogger] \($0)") }
    }
}

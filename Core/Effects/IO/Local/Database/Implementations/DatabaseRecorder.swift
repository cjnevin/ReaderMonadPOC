//
//  DatabaseRecorder.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public class DatabaseRecorder: DatabaseDecorator, Recorder {
    public private(set) var events: [String] = []
    public override init(_ database: Database) {
        super.init(database)
        decorator = { self.events.append("\($0)") }
    }
}

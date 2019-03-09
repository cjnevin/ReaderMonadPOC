//
//  Async.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public typealias Sync = (@escaping () -> Void) -> Void

public let backgroundSync: Sync = { execute in DispatchQueue.global(qos: .background).async(execute: execute) }
public let mainSync: Sync = { execute in execute() }

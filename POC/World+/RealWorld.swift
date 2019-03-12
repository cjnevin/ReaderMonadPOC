//
//  RealWorld.swift
//  POC
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core
import World

let realWorld = World(
    analytics: analyticsLogger,
    database: DatabaseLogger(RealmDatabase()),
    download: downloadLogger(URLSession.shared.download),
    disk: DiskLogger(MemoryDisk()),
    executor: requestLogger(URLSession.shared.execute),
    navigate: navigationLogger(navigate),
    sync: backgroundSync)

let realWorldStore = Store(
    reducer: reducerLogger(appReducer),
    interpreter: interpreterLogger(worldInterpreter(world: realWorld)),
    initialState: AppState())

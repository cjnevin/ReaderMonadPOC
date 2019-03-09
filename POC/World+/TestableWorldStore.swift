//
//  TestableWorldStore.swift
//  POC
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core
import World
@testable import POC

class TestableWorldStore {
    var reducer: WorldReducer<AppState, AppAction>! = appReducer
    var reducerRecorder: ReducerRecorder<AppState, AppAction, World, WorldError>!
    var interpreter: WorldInterpreter<AppAction>!

    func makeStore(world: World) -> WorldStore<AppState, AppAction> {
        reducerRecorder = ReducerRecorder(reducer: reducer)
        interpreter = worldInterpreter(world: world)
        return Store(
            reducer: reducerRecorder.reducer,
            interpreter: interpreter,
            initialState: AppState())
    }
}

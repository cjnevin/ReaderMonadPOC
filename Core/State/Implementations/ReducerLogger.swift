//
//  ReducerLogger.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func reducerLogger<S, A, W, E>(_ reducer: Reducer<S, A, W, E>) -> Reducer<S, A, W, E> {
    return .init { state, action in
        print("[ActionLogger] - \(action)")
        return reducer.reduce(&state, action)
    }
}

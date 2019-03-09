//
//  ReducerLogger.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func reducerLogger<S, A, W>(_ reducer: Reducer<S, A, W>) -> Reducer<S, A, W> {
    return .init { state, action in
        print("[ActionLogger] - \(action)")
        return reducer.reduce(&state, action)
    }
}

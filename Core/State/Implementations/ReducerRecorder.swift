//
//  ReducerRecorder.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public final class ReducerRecorder<S, A, W>: Recorder {
    public typealias E = ReaderEffect<W, A>
    public private(set) var reducer: Reducer<S, A, W>!
    public private(set) var events: [(S, S, A, E)] = []

    public init(reducer: Reducer<S, A, W>) {
        self.reducer = .init { state, action in
            let oldState = state
            let effect = reducer.reduce(&state, action)
            self.events.append((oldState, state, action, effect))
            return effect
        }
    }
    
    public subscript<T>(keyPath: KeyPath<S, T>) -> [(T, T, A, E)] {
        return events.map { (args) in
            let (old, new, action, effect) = args
            return (old[keyPath: keyPath], new[keyPath: keyPath], action, effect)
        }
    }
}

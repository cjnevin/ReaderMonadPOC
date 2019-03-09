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

    public subscript<T, U>(keyPath1: KeyPath<S, T>, keyPath2: KeyPath<S, U>) -> [(T, U, T, U, A, E)] {
        return events.map { (args) in
            let (old, new, action, effect) = args
            return (old[keyPath: keyPath1],
                    old[keyPath: keyPath2],
                    new[keyPath: keyPath1],
                    new[keyPath: keyPath2],
                    action, effect)
        }
    }

    public subscript<T, U, V>(keyPath1: KeyPath<S, T>, keyPath2: KeyPath<S, U>, keyPath3: KeyPath<S, V>) -> [(T, U, V, T, U, V, A, E)] {
        return events.map { (args) in
            let (old, new, action, effect) = args
            return (old[keyPath: keyPath1],
                    old[keyPath: keyPath2],
                    old[keyPath: keyPath3],
                    new[keyPath: keyPath1],
                    new[keyPath: keyPath2],
                    new[keyPath: keyPath3],
                    action, effect)
        }
    }
}

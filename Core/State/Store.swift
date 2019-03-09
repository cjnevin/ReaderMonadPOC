//
//  Store.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public final class Store<S, A, W> {
    private let reducer: Reducer<S, A, W>
    private let interpreter: Interpreter<W, A>
    public private(set) var currentState: S

    public init(reducer: Reducer<S, A, W>,
         interpreter: @escaping Interpreter<W, A>,
         initialState: S) {
        self.reducer = reducer
        self.interpreter = interpreter
        self.currentState = initialState
    }

    public func dispatch(_ action: A) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.dispatch(action)
            }
            return
        }
        assert(Thread.isMainThread)
        interpreter(reducer.reduce(&currentState, action), dispatch)
    }
}

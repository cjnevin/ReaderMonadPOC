//
//  Store.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public final class Store<S, A, W> {
    public typealias Token = Int
    private var token = (0...).makeIterator()
    private var subscribers: [Token: (S) -> Void] = [:]
    private let reducer: Reducer<S, A, W>
    private let interpreter: Interpreter<W, A>
    private(set) public var currentState: S {
        didSet { self.notitySubscribers() }
    }

    private func notitySubscribers() {
        assert(Thread.isMainThread)
        self.subscribers.values.forEach { $0(self.currentState) }
    }

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

    public func subscribe(_ subscriber: @escaping (S) -> Void) -> Token {
        assert(Thread.isMainThread)
        let tkn = self.token.next()!
        self.subscribers[tkn] = subscriber
        subscriber(self.currentState)
        return tkn
    }

    public func unsubscribe(_ token: Token) {
        assert(Thread.isMainThread)
        self.subscribers.removeValue(forKey: token)
    }
}

public struct NoError { }

extension Store {
    public func observe() -> Signal<S, NoError> {
        return Signal { observer -> Disposable in
            let token = self.subscribe { state in
                observer.next(state)
            }
            return AnonymousDisposable {
                self.unsubscribe(token)
            }
        }
    }
}

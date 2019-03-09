//
//  Observer.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public enum Event<T, E> {
    case next(T)
    case error(E)
    case completed
}

public protocol ObserverType {
    associatedtype T
    associatedtype E
    func on(event: Event<T, E>)
}

public final class Observer<T, E>: ObserverType {
    private let handler: (Event<T, E>) -> Void

    public init(handler: @escaping (Event<T, E>) -> Void) {
        self.handler = handler
    }

    public func on(event: Event<T, E>) {
        if case .error(is NoError) = event {
            handler(.completed)
        } else {
            handler(event)
        }
    }
}

public extension Observer {
    public func completed() {
        on(event: .completed)
    }

    public func next(_ element: T) {
        on(event: .next(element))
    }

    public func error(_ error: E) {
        on(event: .error(error))
    }
}

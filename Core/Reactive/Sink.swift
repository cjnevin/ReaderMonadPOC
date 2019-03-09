//
//  Sink.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public final class Sink<O: ObserverType>: Disposable {
    private var isDisposed: Bool = false
    private let forward: O
    private let subscriptionHandler: (Observer<O.T, O.E>) -> Disposable
    private let disposable = CompositeDisposable()

    public init(forward: O, subscriptionHandler: @escaping (Observer<O.T, O.E>) -> Disposable) {
        self.forward = forward
        self.subscriptionHandler = subscriptionHandler
    }

    public func run() {
        let observer = Observer<O.T, O.E>(handler: forward)
        disposable += subscriptionHandler(observer)
    }

    private func forward(event: Event<O.T, O.E>) {
        if isDisposed { return }
        forward.on(event: event)
        switch event {
        case .completed, .error:
            dispose()
        default:
            break
        }
    }

    public func dispose() {
        isDisposed = true
        disposable.dispose()
    }
}

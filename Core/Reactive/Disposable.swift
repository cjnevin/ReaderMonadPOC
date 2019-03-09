//
//  Disposable.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func + (l: Disposable, r: Disposable) -> Disposable {
    switch (l, r) {
    case let (lhs as CompositeDisposable, rhs as CompositeDisposable):
        return CompositeDisposable(lhs.disposables + rhs.disposables)
    case let (lhs as CompositeDisposable, rhs):
        lhs.add(rhs)
        return lhs
    case let (lhs, rhs as CompositeDisposable):
        rhs.add(lhs)
        return rhs
    default:
        return CompositeDisposable([l, r])
    }
}

public func += (l: CompositeDisposable, r: Disposable) {
    l.add(r)
}

public protocol Disposable: AnyObject {
    func dispose()
}

public final class Indisposable: Disposable {
    public init() { }
    public func dispose() { }
}

public final class AnonymousDisposable: Disposable {
    private let disposeHandler: () -> Void

    public init(_ disposeClosure: @escaping () -> Void) {
        disposeHandler = disposeClosure
    }

    public func dispose() {
        disposeHandler()
    }
}

public final class CompositeDisposable: Disposable {
    private var isDisposed: Bool = false
    fileprivate var disposables: [Disposable] = []

    public init() {}

    public init(_ disposables: [Disposable]) {
        self.disposables = disposables
    }

    public func add(_ disposable: Disposable) {
        if isDisposed {
            disposable.dispose()
            return
        }
        disposables.append(disposable)
    }

    public func remove<T: Disposable>(_ disposable: T) {
        disposables = disposables.filter { $0 !== disposable }
    }

    public func dispose() {
        if isDisposed { return }
        disposables.forEach { $0.dispose() }
        isDisposed = true
    }
}

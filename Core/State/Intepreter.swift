//
//  Intepreter.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public typealias ReaderEffect<W, A> = Effect<Reader<W, A>>
public typealias Interpreter<W, A> = (Interpretable<W, A>, @escaping (A) -> Void) -> Void
public typealias Interpretable<W, A> = DispatchMethod<W, A>

public enum DispatchMethod<W, A> {
    case sequence([DispatchMethod<W, A>])
    case void(ReaderEffect<W, Void>)
    case action(ReaderEffect<W, A>)
    case actions(ReaderEffect<W, Observable<A, NoError>>, disposedBy: CompositeDisposable)

    public static var identity: DispatchMethod<W, A> {
        return .void(.identity)
    }
}

extension DispatchMethod: Monoid {
    public func combine(with other: DispatchMethod) -> DispatchMethod {
        switch (self, other) {
        case let (.sequence(lhs), .sequence(rhs)): return .sequence(lhs <> rhs)
        case let (.sequence(lhs), _): return .sequence(lhs <> [other])
        case let (_, .sequence(rhs)): return .sequence([self] <> rhs)
        default: return .sequence([self, other])
        }
    }
}

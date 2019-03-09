//
//  Intepreter.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public typealias ReaderEffect<W, T> = Effect<Reader<W, T>>
public typealias Interpreter<W, A, E> = (Interpretable<W, A, E>, @escaping (A) -> Void) -> Void
public typealias Interpretable<W, A, E> = DispatchMethod<W, A, E>

public enum DispatchMethod<W, A, E> {
    case immediate(ReaderEffect<W, A>)
    case recurring(ReaderEffect<W, Observable<A, E>>, CompositeDisposable)

    public static var identity: DispatchMethod<W, A, E> {
        return .immediate(.identity)
    }
}

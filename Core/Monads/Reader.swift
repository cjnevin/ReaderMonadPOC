//
//  Reader.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public struct Reader<E, A> {
    private let g: (E) -> A

    public init(_ g: @escaping (E) -> A) {
        self.g = g
    }

    public static func pure(_ a: A) -> Reader<E, A> {
        return .init { e in a }
    }

    public func apply(_ e: E) -> A {
        return g(e)
    }

    public func map<B>(_ f: @escaping (A) -> B) -> Reader<E, B> {
        return Reader<E, B>{ e in f(self.g(e)) }
    }

    public func flatMap<B>(_ f: @escaping (A) -> Reader<E, B>) -> Reader<E, B> {
        return Reader<E, B>{ e in f(self.g(e)).g(e) }
    }
}

public func >>>= <E, A, B>(a: Reader<E, A>, f: @escaping (A) -> Reader<E, B>) -> Reader<E, B> {
    return a.flatMap(f)
}

//
//  Reader.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public struct Reader<W, A> {
    private let g: (W) -> A

    public init(_ g: @escaping (W) -> A) {
        self.g = g
    }

    public static func pure(_ a: A) -> Reader<W, A> {
        return .init { e in a }
    }

    public func apply(_ world: W) -> A {
        return g(world)
    }

    public func map<B>(_ f: @escaping (A) -> B) -> Reader<W, B> {
        return Reader<W, B>{ e in f(self.g(e)) }
    }

    public func flatMap<B>(_ f: @escaping (A) -> Reader<W, B>) -> Reader<W, B> {
        return Reader<W, B>{ e in f(self.g(e)).g(e) }
    }
}

public func >>>= <W, A, B>(a: Reader<W, A>, f: @escaping (A) -> Reader<W, B>) -> Reader<W, B> {
    return a.flatMap(f)
}

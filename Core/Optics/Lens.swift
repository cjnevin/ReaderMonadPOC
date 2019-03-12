//
//  Lens.swift
//  Core
//
//  Created by Chris Nevin on 12/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public struct Lens<Whole, Part> : LensType {
    public let view: (Whole) -> Part
    public let set: (Part, Whole) -> Whole

    public init(view: @escaping (Whole) -> Part, set: @escaping (Part, Whole) -> Whole) {
        self.view = view
        self.set = set
    }
}

public protocol LensType {
    associatedtype Whole
    associatedtype Part

    init(view: @escaping (Whole) -> Part, set: @escaping (Part, Whole) -> Whole)

    var view: (Whole) -> Part { get }
    var set: (Part, Whole) -> Whole { get }
}

public extension LensType {
    public func over(_ f: @escaping (Part) -> Part) -> (Whole) -> Whole {
        return { a in self.set(f(self.view(a)), a) }
    }

    public func compose <RLens: LensType>(_ rhs: RLens) -> Lens<Whole, RLens.Part> where RLens.Whole == Part {
        return Lens(
            view: { a in rhs.view(self.view(a)) },
            set: { (c, a) in self.set(rhs.set(c, self.view(a)), a) }
        )
    }
}

public func *~ <L: LensType> (lens: L, b: L.Part) -> (L.Whole) -> L.Whole {
    return { a in lens.set(b, a) }
}

public func ^* <L: LensType> (a: L.Whole, lens: L) -> L.Part {
    return lens.view(a)
}

public func • <A, B, C> (lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    return lhs.compose(rhs)
}

public func %~ <L: LensType> (lens: L, f: @escaping (L.Part) -> L.Part) -> (L.Whole) -> L.Whole {
    return lens.over(f)
}

public func lens<A, B>(_ keyPath: WritableKeyPath<A, B>) -> Lens<A, B> {
    return Lens<A, B>(
        view: { $0[keyPath: keyPath] },
        set: { part, whole in
            var newWhole = whole
            newWhole[keyPath: keyPath] = part
            return newWhole
        }
    )
}

//
//  Monoid.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public protocol Monoid: Semigroup {
    static var identity: Self { get }
}

extension Numeric where Self: Monoid {
    public static var identity: Self { return 0 }
}

extension Int: Monoid { }

extension Bool: Monoid {
    public static let identity = true
}

extension String: Monoid {
    public static let identity = ""
}

extension Array: Monoid {
    public static var identity: Array {
        return []
    }
}

extension Dictionary: Monoid {
    public static var identity: Dictionary {
        return [:]
    }
}

public func concat<M: Monoid>(_ xs: [M]) -> M {
    return xs.reduce(M.identity, <>)
}

extension Sequence where Element: Monoid {
    public func joined() -> Element {
        return concat(Array(self))
    }
}

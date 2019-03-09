//
//  Function.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public struct Function<A, B> {
    public let call: (A) -> B

    public init (_ f: @escaping (A) -> B) {
        self.call = f
    }
}

extension Function: Semigroup where B: Semigroup {
    public func combine(with other: Function) -> Function {
        return Function { self.call($0).combine(with: other.call($0)) }
    }
}

extension Function: Monoid where B: Monoid {
    public static var identity: Function {
        return Function { _ in B.identity }
    }
}

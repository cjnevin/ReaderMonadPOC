//
//  Combine.swift
//  Core
//
//  Created by Chris Nevin on 11/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

infix operator <>: AdditionPrecedence

public func <> <A, B, C> (f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}

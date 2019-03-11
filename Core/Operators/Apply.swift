//
//  Apply.swift
//  Core
//
//  Created by Chris Nevin on 11/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

precedencegroup ApplyPrecedence {
    associativity: left
}

infix operator |>: ApplyPrecedence

public func |> <A, B> (x: A, f: @escaping (A) -> B) -> B {
    return f(x)
}

//
//  Operators.swift
//  Core
//
//  Created by Chris Nevin on 12/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

precedencegroup ViewPrecedence {
    associativity: left
}

infix operator ^*: ViewPrecedence

precedencegroup SetPrecedence {
    associativity: left
    higherThan: ViewPrecedence
}

infix operator *~: SetPrecedence

precedencegroup OverPrecedence {
    associativity: left
    higherThan: ViewPrecedence
}

infix operator %~: OverPrecedence

precedencegroup CompositionPrecedence {
    associativity: left
    higherThan: OverPrecedence
}

infix operator •: CompositionPrecedence

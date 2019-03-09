//
//  Effect.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public enum Effect<A> {
    case sequence([Effect<A>])
    case background(A)
    case main(A)

    public static var identity: Effect<A> { return Effect<A>.sequence([]) }
}

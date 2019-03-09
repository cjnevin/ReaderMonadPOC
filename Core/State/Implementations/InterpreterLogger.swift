//
//  EffectLogger.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func interpreterLogger<W, A, E>(_ interpreter: @escaping Interpreter<W, A, E>) -> Interpreter<W, A, E> {
    return { effect, dispatch in
        print("[EffectLogger] - \(effect)]")
        interpreter(effect, dispatch)
    }
}

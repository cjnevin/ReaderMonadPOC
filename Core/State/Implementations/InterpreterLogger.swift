//
//  EffectLogger.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func interpreterLogger<W, A>(_ interpreter: @escaping Interpreter<W, A>) -> Interpreter<W, A> {
    return { effect, dispatch in
        print("[EffectLogger] - \(effect)]")
        interpreter(effect, dispatch)
    }
}

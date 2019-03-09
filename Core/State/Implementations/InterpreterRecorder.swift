//
//  InterpreterRecorder.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public final class InterpreterRecorder<W, A, E> {
    public private(set) var interpreter: Interpreter<W, A, E>!
    public private(set) var effects: [Interpretable<W, A, E>] = []

    public init(interpreter: @escaping Interpreter<W, A, E>) {
        self.interpreter = { effect, dispatch in
            self.effects.append(effect)
            interpreter(effect, dispatch)
        }
    }
}

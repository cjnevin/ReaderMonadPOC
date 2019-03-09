//
//  Intepreter.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public typealias ReaderEffect<W, T> = Effect<Reader<W, T>>
public typealias Interpreter<W, A> = (ReaderEffect<W, A>, @escaping (A) -> Void) -> Void

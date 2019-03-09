//
//  Reducer.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public struct Reducer<S, A, W> {
    public let reduce: (inout S, A) -> ReaderEffect<W, A>

    public init(_ reduce: @escaping (inout S, A) -> ReaderEffect<W, A>) {
        self.reduce = reduce
    }
}

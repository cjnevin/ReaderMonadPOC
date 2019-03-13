//
//  Await.swift
//  Core
//
//  Created by Chris Nevin on 12/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func await<T>(_ closure: @escaping (@escaping () -> ()) throws -> T) rethrows -> T {
    let semaphore = DispatchSemaphore(value: 0)
    let result = try closure() { semaphore.signal() }
    _ = semaphore.wait(timeout: .distantFuture)
    return result
}

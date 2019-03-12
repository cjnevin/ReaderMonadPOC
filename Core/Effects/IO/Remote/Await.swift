//
//  Await.swift
//  Core
//
//  Created by Chris Nevin on 12/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func await(_ closure: @escaping (@escaping () -> ()) -> Void) {
    let semaphore = DispatchSemaphore(value: 0)
    closure() { semaphore.signal() }
    _ = semaphore.wait(timeout: .distantFuture)
}

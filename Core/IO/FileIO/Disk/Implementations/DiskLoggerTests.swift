//
//  DiskLoggerTests.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

class DiskLoggerTests: DiskTests {
    override func setUp() {
        super.setUp()
        self.sut = DiskLogger(MemoryDisk())
        self.path = URL(fileURLWithPath: NSTemporaryDirectory())
    }
}

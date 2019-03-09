//
//  MemoryDiskTests.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

class MemoryDiskTests: DiskTests {
    override func setUp() {
        super.setUp()
        self.sut = MemoryDisk()
        self.path = URL(fileURLWithPath: NSTemporaryDirectory())
    }
}

//
//  DiskRecorderTests.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

class DiskRecorderTests: DiskTests {
    override func setUp() {
        super.setUp()
        self.sut = DiskRecorder(MemoryDisk())
        self.path = URL(fileURLWithPath: NSTemporaryDirectory())
    }
}

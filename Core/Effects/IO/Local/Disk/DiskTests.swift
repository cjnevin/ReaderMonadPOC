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

class DiskTests: XCTestCase {
    var sut: Disk!
    var path: URL!
    var isRoot: Bool {
        return type(of: self) == DiskTests.self
    }

    func testWriteRead() {
        if isRoot { return }
        XCTAssertTrue(sut.writeRead(data: Data(), path: path))
    }

    func testWriteDeleteRead() {
        if isRoot { return }
        XCTAssertTrue(sut.writeDeleteRead(data: Data(), path: path))
    }

    func testReadErrors() {
        if isRoot { return }
        XCTAssertTrue(Result.prism.failure.isCase(sut.read(from: path)))
    }

    func testDeleteErrors() {
        if isRoot { return }
        XCTAssertTrue(Result.prism.failure.isCase(sut.delete(from: path)))
    }
}


//
//  TestableDataTests.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

class TestableDatabaseTests: DatabaseTests {
    override func setUp() {
        super.setUp()
        self.sut = TestableDatabase(MemoryDatabase())
        self.id = "test"
    }

    func testReturnsReadError() {
        (sut as! TestableDatabase).readError = .notFound
        XCTAssertTrue(Result.prism.failure.isCase(sut.read(id: id, ofType: DatabaseObject.self)))
    }

    func testReturnsWriteError() {
        (sut as! TestableDatabase).writeError = .notWritable
        XCTAssertTrue(Result.prism.failure.isCase(sut.write(DatabaseObject(id: "test"), for: id)))
    }
}

//
//  DatabaseTests.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

class DatabaseTests: XCTestCase {
    var sut: Database!
    var id: String!
    var isRoot: Bool {
        return type(of: self) == DatabaseTests.self
    }

    func testWriteRead() {
        if isRoot { return }
        XCTAssertTrue(sut.writeRead(DatabaseObject(id: "test"), for: id))
    }

    func testReadErrors() {
        if isRoot { return }
        XCTAssertTrue(Result.prism.failure.isCase(sut.read(id: id, ofType: DatabaseObject.self)))
    }

    override func tearDown() {
        super.tearDown()
        databaseSource = [:]
    }
}

private var databaseSource: [String: DatabaseObject] = [:]
struct DatabaseObject: DatabaseReadable, DatabaseWritable, Equatable {
    let id: String

    static func read(id: String) -> DatabaseObject? {
        return databaseSource[id]
    }

    func write(for id: String) -> Bool {
        databaseSource[id] = self
        return true
    }
}


//
//  AppStateTests.swift
//  POCTests
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import XCTest
import Core
@testable import POC

class AppStateTests: WorldStoreTest {
    func testDownloadFailure() {
        testableWorld.downloadResult = .failure(.unknown)
        store.dispatch(.download(.start))
        assert(keyPath: \AppState.isLoading)
    }

    func testDownloadSuccess() {
        testableWorld.downloadResult = .success(Data())
        store.dispatch(.download(.start))
        assert(keyPath: \AppState.isLoading)
    }

    func testLoginSuccess() {
        store.dispatch(.login(.send))
        assert(keyPaths: \AppState.user, \AppState.isLoading)
    }

    func testLoginFailure() {
        testableWorld.database.writeError = .notWritable
        store.dispatch(.login(.send))
        assert(keyPaths: \AppState.user, \AppState.isLoading)
    }
}

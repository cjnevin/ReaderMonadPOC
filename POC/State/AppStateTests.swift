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

class AppStateTests: StoreTest {
    func testDownloadFailure() {
        downloadResult = .failure(.unknown)
        store.dispatch(.download(.start))
        assert(keyPath: \AppState.isLoading)
    }

    func testDownloadSuccess() {
        downloadResult = .success(Data())
        store.dispatch(.download(.start))
        assert(keyPath: \AppState.isLoading)
    }

    func testLoginSuccess() {
        store.dispatch(.login(.sent))
        assert(keyPath: \AppState.user)
    }

    func testLoginFailure() {
        database.writeError = .notWritable
        store.dispatch(.login(.sent))
        assert(keyPath: \AppState.user)
    }
}

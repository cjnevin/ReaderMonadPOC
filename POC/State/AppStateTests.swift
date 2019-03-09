//
//  AppStateTests.swift
//  POCTests
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import XCTest
import Core
import World
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

    func testUserInjection() {
        store.dispatch(.users(.inject(User(id: "id1", name: "name1"))))
        assert(keyPath: \AppState.isLoading)
    }

    func testUserWatchFailure() {
        store.dispatch(.users(.watch))
        assert(keyPath: \AppState.latestUsers)
    }

    func testUserWatchSuccess() {
        _ = testableWorld.database.write(User(id: "id1", name: "name1"), for: "id1")
        store.dispatch(.users(.watch))
        assert(keyPath: \AppState.latestUsers)
    }
}

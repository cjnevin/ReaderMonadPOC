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

extension User {
    static func fake(n: Int = 1) -> User {
        return User(id: "id\(n)", name: "name\(n)")
    }
}

class AppStateTests: WorldStoreTest {
    func testUserListScreen() {
        store.dispatch(.screen(.userList))
        assert(keyPath: \AppState.currentScreen)
    }

    func testUserDetailsScreen() {
        store.dispatch(.screen(.userDetails))
        assert(keyPath: \AppState.currentScreen)
    }

    func testSelectUserThenComeBackSetsThenClearsUser() {
        store.dispatch(.users(.select(.fake())))
        store.dispatch(.screen(.userList))
        assert(keyPath: \AppState.selectedUser)
    }

    func testSelectUser() {
        store.dispatch(.users(.select(.fake())))
        assert(keyPath: \AppState.currentScreen)
    }

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
        store.dispatch(.users(.inject(.fake())))
        assert(keyPath: \AppState.isLoading)
    }

    func testUserWatchFailure() {
        store.dispatch(.users(.watch))
        assert(keyPath: \AppState.latestUsers)
    }

    func testUserWatchSuccess() {
        _ = testableWorld.database.write(User.fake(), for: "id1")
        store.dispatch(.users(.watch))
        assert(keyPath: \AppState.latestUsers)
    }
}

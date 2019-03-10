//
//  AppState.swift
//  POC
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core
import World

//sourcery:prism=chain
enum AppAction {
    //sourcery:prism=chain
    enum Download {
        case start
        case complete
        case failed
    }

    //sourcery:prism=chain
    enum Users {
        case inject(User)
        case injected(User)

        case watch
        case received([User])
        case failed
        
        case select(User)
    }

    case download(Download)
    case users(Users)
    case screen(Screen)
}

struct AppState {
    var isLoading: Bool = false
    var latestUsers: [User] = []
    var selectedUser: User? = nil
    var currentScreen: Screen? = nil
}

let appReducer = WorldReducer<AppState, AppAction> { state, action in
    switch action {
    case .screen(let screen):
        state.currentScreen = screen
        if screen == .userList {
            state.selectedUser = nil
        }
        return .identity
    case .download(let download):
        switch download {
        case .start:
            state.isLoading = true
            return .action(.background(downloadTheInternet))
        case .complete:
            state.isLoading = false
            return .track(event: .userList("download complete"))
        case .failed:
            state.isLoading = false
            return .track(event: .userList("download failed"))
        }
    case .users(let users):
        switch users {
        case .inject(let user):
            state.isLoading = true
            return .action(.background(inject(user: user)))
        case .injected(let user):
            state.isLoading = false
            return .track(event: .userList("injected \(user.id)"))
        case .watch:
            state.isLoading = true
            return .actions(.main(fetchUsers()), disposedBy: disposal(for: .userList)())
        case .received(let allUsers):
            // Optimisation: sorting and filtering should be moved to store
            state.latestUsers = allUsers.last(10).sorted()
            state.isLoading = false
            return .track(event: .userList("received \(allUsers.count) users"))
        case .failed:
            state.isLoading = false
            return .track(event: .userList("failed"))
        case .select(let user):
            state.selectedUser = user
            return .track(event: .userList("selected user"))
                <> .go(to: .userDetails)
        }
    }
}

extension Array {
    func last(_ items: Int) -> [Element] {
        return count > items ? Array(suffix(items)) : self
    }
}

extension DispatchMethod where W == World, A == AppAction {
    static func track(event: AnalyticsComponent) -> DispatchMethod {
        return .void(.background(trackAnalytics(event: event)))
    }

    static func go(to screen: Screen) -> DispatchMethod {
        return .void(.main(navigate(to: screen)))
    }
}

private let google = URL(string: "https://www.google.com")!
private let cache = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("cache").appendingPathExtension("txt")
private let downloads = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent("download").appendingPathExtension("txt")

private let downloadTheInternet
    = download(from: google, cacheAt: cache, thenMoveTo: downloads)
        >>>= { .pure($0.map(AppAction.prism.download.complete.review) ?? AppAction.download(.failed)) }

private func inject(user: User) -> WorldReader<AppAction> {
    return trackAnalytics(event: .userList("inject user"))
        >>>= { writeToDatabase(user, for: user.id) }
        >>>= { .pure($0.map(AppAction.prism.users.injected.review) ?? AppAction.users(.failed)) }
}

private func fetchUsers() -> WorldReader<ErrorlessSignal<AppAction>> {
    return .init { world in
        world.database.objects(ofType: User.self)
            .map(AppAction.prism.users.received.review)
            .noError()
    }
}

extension User {
    static func random() -> User {
        return User(id: UUID().uuidString, name: randomString(length: 15))
    }
}

private func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
}

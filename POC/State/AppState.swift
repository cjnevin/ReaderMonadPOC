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
    }

    case download(Download)
    case users(Users)
}

struct AppState {
    var isLoading: Bool = false
    var latestUsers: [User] = []
}

let appReducer = WorldReducer<AppState, AppAction> { state, action in
    let dispose = disposal(for: .root)
    switch action {
    case .download(let download):
        switch download {
        case .start:
            state.isLoading = true
            return .immediate(.background(downloadTheInternet))
        case .complete:
            state.isLoading = false
        case .failed:
            state.isLoading = false
        }
    case .users(let users):
        switch users {
        case .inject(let user):
            state.isLoading = true
            return .immediate(.background(inject(user: user)))
        case .injected(let user):
            state.isLoading = false
            return .identity
        case .watch:
            state.isLoading = true
            return .recurring(.main(fetchUsers()), dispose())
        case .received(let allUsers):
            state.latestUsers = allUsers.last(10).sorted()
            state.isLoading = false
        case .failed:
            state.isLoading = false
        }
    }
    return .identity
}

extension Array {
    func last(_ items: Int) -> [Element] {
        return count > items ? Array(suffix(items)) : self
    }
}

private let google = URL(string: "https://www.google.com")!
private let cache = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("cache").appendingPathExtension("txt")
private let downloads = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent("download").appendingPathExtension("txt")

private let downloadTheInternet
    = download(url: google, cacheAt: cache, thenMoveTo: downloads)
        >>>= { .pure($0.map(AppAction.prism.download.complete.review) ?? AppAction.download(.failed)) }

private func inject(user: User) -> WorldReader<AppAction> {
    return .pure(user)
        >>>= { writeToDatabase($0, for: $0.id) }
        >>>= { .pure($0.map(AppAction.prism.users.injected.review) ?? AppAction.users(.failed)) }
}

private func fetchUsers() -> Recurring<AppAction> {
    return Recurring<AppAction> { world in
        world.database.objects(ofType: User.self)
            .map(AppAction.prism.users.received.review)
            .mapError(WorldError.prism.database.read.review)
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

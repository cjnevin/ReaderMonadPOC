//
//  AppState.swift
//  POC
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core

enum AppAction {
    enum Login {
        case sent
        case success(User)
        case failed
    }

    enum Download {
        case start
        case complete
        case failed
    }

    case download(Download)
    case login(Login)
}

struct AppState {
    var isLoading: Bool = false
    var user: User? = nil
}

let appReducer = WorldReducer<AppState, AppAction> { state, action in
    switch action {
    case .download(let download):
        switch download {
        case .start:
            state.isLoading = true
            return .background(downloadThenComplete)
        case .complete:
            state.isLoading = false
        case .failed:
            state.isLoading = false
        }
    case .login(let login):
        switch login {
        case .sent:
            state.user = nil
            return .background(sendCredentials)
        case .success(let user):
            state.user = user
        case .failed:
            state.user = nil
        }
    }
    return .identity
}

private let google = URL(string: "https://www.google.com")!
private let downloadToCache = download(from: google, into: "cache")
private let copyToDocuments = copyFile(from: "cache", to: "documents")
private let deleteFromCache = deleteFile(at: "cache")
private let downloadThenComplete
    = downloadToCache
        >>>= { copyToDocuments }
        >>>= { deleteFromCache }
        >>>= { .pure($0.map { AppAction.download(.complete) } ?? AppAction.download(.failed)) }

private let sendCredentials
    = WorldReader.pure(User(id: "id", name: "name"))
        >>>= { writeToDatabase($0, for: $0.id) }
        >>>= { .pure($0.map { AppAction.login(.success($0)) } ?? AppAction.login(.failed)) }

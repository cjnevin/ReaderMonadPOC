//
//  AppState.swift
//  POC
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core

//sourcery:prism=chain
enum AppAction {
    //sourcery:prism=chain
    enum Login {
        case send
        case success(User)
        case failed
    }

    //sourcery:prism=chain
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
        case .send:
            state.isLoading = true
            state.user = nil
            return .background(sendCredentials)
        case .success(let user):
            state.isLoading = false
            state.user = user
        case .failed:
            state.isLoading = false
            state.user = nil
        }
    }
    return .identity
}

private let google = URL(string: "https://www.google.com")!
private let cache = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("cache").appendingPathExtension("txt")
private let downloads = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent("download").appendingPathExtension("txt")
private let downloadToCache = download(from: google, into: cache)
private let copyToDocuments = copyFile(from: cache, to: downloads)
private let deleteFromCache = deleteFile(at: cache)
private let downloadThenComplete
    = downloadToCache
        >>>= { copyToDocuments }
        >>>= { deleteFromCache }
        >>>= { .pure($0.map(AppAction.prism.download.complete.review) ?? AppAction.download(.failed)) }

private let sendCredentials
    = .pure(User(id: "id", name: "name"))
        >>>= { writeToDatabase($0, for: $0.id) }
        >>>= { .pure($0.map(AppAction.prism.login.success.review) ?? AppAction.login(.failed)) }

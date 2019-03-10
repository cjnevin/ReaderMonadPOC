//
//  DisposableDictionary.swift
//  POC
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core

var disposableDictionary: [Screen: CompositeDisposable] = [:]

func disposal(for screen: Screen) -> () -> CompositeDisposable {
    return {
        let d = disposableDictionary[screen] ?? CompositeDisposable()
        disposableDictionary[screen] = d
        return d
    }
}

func dispose(screen: Screen) {
    disposal(for: screen)().dispose()
    disposableDictionary[screen] = CompositeDisposable()
}

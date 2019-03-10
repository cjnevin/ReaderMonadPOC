//
//  NavigationLogger.swift
//  World
//
//  Created by Chris Nevin on 10/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func navigationLogger(
    _ navigator: @escaping Navigator) -> Navigator {
    return navigatorDecorator(
        navigator,
        decorator: { print("[NavigationLogger] \($0)") })
}

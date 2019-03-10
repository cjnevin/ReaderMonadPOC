//
//  NavigatorDecorator.swift
//  World
//
//  Created by Chris Nevin on 10/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func navigatorDecorator(
    _ navigator: @escaping Navigator,
    decorator: @escaping Navigator) -> Navigator {
    return { screen in
        navigator(screen)
        decorator(screen)
    }
}

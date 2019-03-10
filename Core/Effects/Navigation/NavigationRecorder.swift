//
//  NavigationRecorder.swift
//  World
//
//  Created by Chris Nevin on 10/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public class NavigationRecorder {
    public private(set) var events: [String] = []
    public private(set) var navigator: Navigator!
    public init(_ navigator: @escaping Navigator) {
        self.navigator = navigatorDecorator(navigator, decorator: { self.events.append($0) })
    }
}


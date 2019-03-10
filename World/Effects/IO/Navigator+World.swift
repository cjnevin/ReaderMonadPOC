//
//  Navigator+World.swift
//  World
//
//  Created by Chris Nevin on 10/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func navigate(to screen: String) -> WorldReader<Void> {
    return .init { world in
        world.navigate(screen)
    }
}

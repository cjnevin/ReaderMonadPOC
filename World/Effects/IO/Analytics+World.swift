//
//  Analytics+World.swift
//  World
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core

public func trackAnalytics(event: AnalyticsComponent) -> WorldReader<Void> {
    return .init { world in
        world.analytics(event)
    }
}

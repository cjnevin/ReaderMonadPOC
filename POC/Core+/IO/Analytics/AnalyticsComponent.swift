//
//  AnalyticsEvent.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core
import World

extension AnalyticsComponent {
    private static func action(_ value: String) -> AnalyticsComponent {
        return .element(key: "action", value: value)
    }
    private static func label(_ value: String) -> AnalyticsComponent {
        return .element(key: "label", value: value)
    }
    private static func category(_ value: String) -> AnalyticsComponent {
        return .element(key: "category", value: value)
    }
}

extension AnalyticsComponent {
    static func screen(_ screen: Screen) -> AnalyticsComponent {
        return action(screen.rawValue) <> label("viewed") <> category("screen")
    }

    static func userDetails(_ action: String) -> AnalyticsComponent {
        return self.action(action) <> user("details")
    }
    static func userList(_ action: String) -> AnalyticsComponent {
        return self.action(action) <> user("list")
    }
    private static func user(_ label: String) -> AnalyticsComponent {
        return self.label(label) <> self.category("users")
    }
}

//
//  Analytics.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

//sourcery:prism=chain
public indirect enum AnalyticsComponent: Monoid {
    public func combine(with other: AnalyticsComponent) -> AnalyticsComponent {
        switch (self, other) {
        case let (.sequence(lhs), .sequence(rhs)): return .sequence(lhs <> rhs)
        case let (.sequence(lhs), _): return .sequence(lhs <> [other])
        case let (_, .sequence(rhs)): return .sequence([self] <> rhs)
        default: return .sequence([self, other])
        }
    }

    case sequence([AnalyticsComponent])
    case element(key: String, value: Any)

    public static var identity: AnalyticsComponent {
        return .sequence([])
    }

    public var dictionary: [String: Any] {
        switch self {
        case .sequence(let elements):
            return elements.map { $0.dictionary }.reduce([:], { $0.combine(with: $1) })
        case let .element(key, value):
            return [key: value]
        }
    }
}

public typealias AnalyticsTracker = (AnalyticsComponent) -> Void

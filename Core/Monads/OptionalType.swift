//
//  OptionalType.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? {
        return self
    }
}

extension Optional {
    public static var prism: Prism<Optional, Wrapped> {
        return Prism<Optional, Wrapped>(
            preview: { $0 },
            review: Optional.some)
    }
}

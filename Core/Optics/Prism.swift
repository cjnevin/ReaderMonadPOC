//
//  Prism.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public struct Prism<Whole, Part> {
    public let preview: (Whole) -> Part?
    public let review: (Part) -> Whole

    public init(preview: @escaping (Whole) -> Part?,
                review: @escaping (Part) -> Whole) {
        self.preview = preview
        self.review = review
    }
}

extension Prism {
    public func isCase(_ whole: Whole) -> Bool {
        return preview(whole) != nil
    }

    /// Allows us to chain prisms, so we can get/set values in nested enums.
    public func compose<Subpart>(_ other: Prism<Part, Subpart>) -> Prism<Whole, Subpart> {
        return Prism<Whole, Subpart>(
            preview: { self.preview($0).flatMap(other.preview) },
            review: { self.review(other.review($0)) })
    }
}

public func • <A, B, C> (lhs: Prism<A, B>, rhs: Prism<B, C>) -> Prism<A, C> {
    return lhs.compose(rhs)
}

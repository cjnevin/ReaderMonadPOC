//
//  DatabaseQuery.swift
//  Core
//
//  Created by Chris Nevin on 11/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public struct DatabaseQuery<T> {
    public typealias Element = T
    public struct Sort {
        public let key: String
        public let ascending: Bool

        public init(key: String, ascending: Bool) {
            self.key = key
            self.ascending = ascending
        }
    }
    public let predicate: NSPredicate?
    public let sort: Sort?

    public init(filteredBy: NSPredicate? = nil, sortedBy: Sort? = nil) {
        self.predicate = filteredBy
        self.sort = sortedBy
    }
}

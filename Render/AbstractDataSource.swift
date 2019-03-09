//
//  AbstractDataSource.swift
//  Render
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

open class AbstractDataSource<T>: NSObject {
    open var items: [T] = [] {
        didSet { reload() }
    }
    open func reload() { }
}

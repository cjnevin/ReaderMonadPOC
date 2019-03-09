//
//  Disk.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public protocol Disk {
    func delete(from path: String) -> Result<Void, DeleteError>
    func read(from path: String) -> Result<Data, ReadError>
    func write(_ value: Data, to path: String) -> Result<Void, WriteError>
}

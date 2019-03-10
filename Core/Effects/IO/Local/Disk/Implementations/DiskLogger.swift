//
//  DiskLogger.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public class DiskLogger: DiskDecorator {
    public override init(_ disk: Disk) {
        super.init(disk)
        self.decorator = { print("[DiskLogger] \($0)") }
    }
}

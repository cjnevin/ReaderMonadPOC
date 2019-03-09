//
//  DiskRecorder.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public class DiskRecorder: DiskDecorator, Recorder {
    public private(set) var events: [String] = []
    public override init(_ disk: Disk) {
        super.init(disk)
        self.decorator = { self.events.append($0) }
    }
}

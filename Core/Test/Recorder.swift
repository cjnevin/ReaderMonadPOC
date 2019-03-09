//
//  Recorder.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public protocol Recorder {
    associatedtype Event
    var events: [Event] { get }
}

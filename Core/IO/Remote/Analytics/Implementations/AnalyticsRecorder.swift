//
//  AnalyticsRecorder.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public class AnalyticsRecorder {
    public private(set) var events: [String] = []
    public var analytics: AnalyticsTracker!

    public init(_ analytics: @escaping AnalyticsTracker) {
        self.analytics = {
            self.events.append("\($0.dictionary)")
            analytics($0)
        }
    }
}

//
//  AnalyticsLogger.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public let analyticsLogger: AnalyticsTracker = { print("[AnalyticsLogger] \($0.dictionary)") }

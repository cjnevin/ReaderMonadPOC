//
//  TestableWorld.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core

open class TestableWorld {
    open var analytics: AnalyticsTracker = { _ in }
    open var analyticsRecorder: AnalyticsRecorder!

    open var database = TestableDatabase(MemoryDatabase())
    open var databaseRecorder: DatabaseRecorder!

    open var downloadResult: Response = Response.failure(.unknown)
    open var downloadRecorder: DownloadRecorder!

    open var disk: Disk = MemoryDisk()
    open var diskRecorder: DiskRecorder!

    open var response: Response = Response.failure(.unknown)
    open var requestRecorder: RequestRecorder!

    open var navigate: Navigator = { _ in }
    open var navigationRecorder: NavigationRecorder!

    open var sync: Sync = mainSync

    public init() { }

    open func makeWorld() -> World {
        downloadRecorder = DownloadRecorder { _ in self.downloadResult }
        diskRecorder = DiskRecorder(disk)
        databaseRecorder = DatabaseRecorder(database)
        analyticsRecorder = AnalyticsRecorder(analytics)
        navigationRecorder = NavigationRecorder(navigate)
        requestRecorder = RequestRecorder { _ in self.response }
        return World(
            analytics: analyticsRecorder.analytics,
            database: databaseRecorder,
            download: downloadRecorder.downloader,
            disk: diskRecorder,
            executor: requestRecorder.executor,
            navigate: navigationRecorder.navigator,
            sync: sync)
    }
}

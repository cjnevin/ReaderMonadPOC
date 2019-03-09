//
//  TestableWorld.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

open class TestableWorld {
    open var database = TestableDatabase(MemoryDatabase())
    open var databaseRecorder: DatabaseRecorder!

    open var downloadResult: Download = Download.failure(.unknown)
    open var downloadRecorder: DownloadRecorder!

    open var disk: Disk = MemoryDisk()
    open var diskRecorder: DiskRecorder!

    open var sync: Sync = mainSync

    public init() { }

    open func makeWorld() -> World {
        downloadRecorder = DownloadRecorder { _ in self.downloadResult }
        diskRecorder = DiskRecorder(disk)
        databaseRecorder = DatabaseRecorder(database)

        return World(
            database: databaseRecorder,
            download: downloadRecorder.downloader,
            disk: diskRecorder,
            sync: sync)
    }
}

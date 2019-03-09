//
//  DownloadRecorder.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public final class DownloadRecorder: Recorder {
    public private(set) var events: [String] = []
    public private(set) var downloader: Downloader!

    public init(downloader: @escaping Downloader) {
        self.downloader = { url in
            self.events.append(url.absoluteString)
            return downloader(url)
        }
    }
}

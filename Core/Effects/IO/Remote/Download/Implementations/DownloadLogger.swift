//
//  DownloadLogger.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func downloadLogger(_ downloader: @escaping Downloader) -> (URL) -> Result<Data, DownloadError> {
    return { url in
        let result = downloader(url)
        print("[DownloadLogger] '\(url)' - \(result)")
        return result
    }
}

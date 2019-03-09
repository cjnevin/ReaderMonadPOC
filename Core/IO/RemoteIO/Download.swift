//
//  Download.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public enum DownloadError {
    case unknown
    case serverError(Error)
}

public typealias Download = Result<Data, DownloadError>
public typealias Downloader = (URL) -> Download

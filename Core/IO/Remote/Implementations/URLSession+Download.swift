//
//  URLSession+Download.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

extension URLSession {
    public func download(from url: URL) -> Result<Data, DownloadError> {
        var result: Result<Data, DownloadError>?

        let semaphore = DispatchSemaphore(value: 0)
        let blockingDataTask = dataTask(with: url) { data, response, error in
            result = Result.tryMake(success: data, failure: error.map(DownloadError.serverError))
            semaphore.signal()
        }
        blockingDataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return result ?? Result.failure(.unknown)
    }
}

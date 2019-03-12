//
//  RequestLogger.swift
//  Core
//
//  Created by Chris Nevin on 12/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func requestLogger(_ executor: @escaping RequestExecutor) -> (URLRequest) -> Response {
    return { urlRequest in
        let result = executor(urlRequest)
        urlRequest.url.map { print("[RequestLogger] '\($0)' - \(result)") }
        return result
    }
}

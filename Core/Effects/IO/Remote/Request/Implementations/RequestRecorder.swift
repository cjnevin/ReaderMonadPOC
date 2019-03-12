//
//  RequestRecorder.swift
//  Core
//
//  Created by Chris Nevin on 12/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public final class RequestRecorder: Recorder {
    public private(set) var events: [String] = []
    public private(set) var executor: RequestExecutor!

    public init(executor: @escaping RequestExecutor) {
        self.executor = { urlRequest in
            urlRequest.url.map { self.events.append($0.absoluteString) }
            return executor(urlRequest)
        }
    }
}

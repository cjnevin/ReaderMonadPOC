//
//  URLSession+Execute.swift
//  Core
//
//  Created by Chris Nevin on 12/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

extension URLSession {
    public func execute(request: URLRequest) -> Response {
        var result: Response?
        await { signal in
            self.dataTask(with: request) { data, response, error in
                result = Result.tryMake(success: data, failure: error.map(NetworkIOError.serverError))
                signal()
            }.resume()
        }
        return result ?? Result.failure(.unknown)
    }
}

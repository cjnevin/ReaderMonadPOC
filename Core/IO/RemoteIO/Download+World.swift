//
//  Download+World.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func download(from url: URL) -> WorldIOResult<Data> {
    return .init { world in
        world.download(url).mapError(WorldError.download)
    }
}

public func download(from source: URL, into path: String) -> WorldIOResult<Void> {
    return download(from: source) >>>= writeFile(to: path)
}

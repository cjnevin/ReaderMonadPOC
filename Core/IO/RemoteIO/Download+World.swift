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
        world.download(url).catch(WorldError.download)
    }
}

public func download(from source: URL, into path: URL) -> WorldIOResult<Void> {
    return download(from: source) >>>= writeFile(to: path)
}

public func download(url: URL, cacheAt cache: URL, thenMoveTo destination: URL) -> WorldIOResult<Void> {
    return download(from: url, into: cache)
        >>>= { copyFile(from: cache, to: destination) }
        >>>= { deleteFile(at: cache) }
}

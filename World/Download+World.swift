//
//  Download+World.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core

public func download(from url: URL) -> ImmediateResult<Data> {
    return .init { world in
        world.download(url).catch(WorldError.download)
    }
}

public func download(from source: URL, into path: URL) -> ImmediateResult<Void> {
    return download(from: source)
        >>>= writeFile(to: path)
}

public func downloadThenRead(from source: URL, into path: URL) -> ImmediateResult<Data> {
    return download(from: source, into: path)
        >>>= { readFile(at: path) }
}

public func download(url: URL, cacheAt cache: URL, thenMoveTo destination: URL) -> ImmediateResult<Void> {
    return download(from: url, into: cache)
        >>>= { copyFile(from: cache, to: destination) }
        >>>= { deleteFile(at: cache) }
}

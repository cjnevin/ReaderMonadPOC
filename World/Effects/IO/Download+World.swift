//
//  Download+World.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core

public func download(from url: URL) -> WorldReader<WorldResult<Data>> {
    return .init { world in
        world.download(url).catch(WorldError.download)
    }
}

public func download(from source: URL, into destination: URL) -> WorldReader<WorldResult<Void>> {
    return download(from: source)
        >>>= writeFile(to: destination)
}

public func downloadThenRead(from source: URL, into destination: URL) -> WorldReader<WorldResult<Data>> {
    return download(from: source, into: destination)
        >>>= { readFile(at: destination) }
}

public func download(from source: URL, cacheAt cache: URL, thenMoveTo destination: URL) -> WorldReader<WorldResult<Void>> {
    return download(from: source, into: cache)
        >>>= { copyFile(from: cache, to: destination) }
        >>>= { deleteFile(at: cache) }
}

//
//  Disk+World.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public func deleteFile(at path: String) -> WorldIOResult<Void> {
    return .init { world in
        world.disk.delete(from: path).mapError { WorldError.disk(.delete($0)) }
    }
}

public func readFile(at path: String) -> WorldIOResult<Data> {
    return .init { world in
        world.disk.read(from: path).mapError { WorldError.disk(.read($0)) }
    }
}

public func writeFile(to path: String) -> (Data) -> WorldIOResult<Void> {
    return { data in
        return .init { world in
            world.disk.write(data, to: path).mapError { WorldError.disk(.write($0)) }
        }
    }
}

public func copyFile(from source: String, to destination: String) -> WorldIOResult<Void> {
    return readFile(at: source) >>>= writeFile(to: destination)
}

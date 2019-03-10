//
//  Disk+World.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core

public func deleteFile(at path: URL) -> WorldReader<WorldResult<Void>> {
    return .init { world in
        world.disk.delete(from: path)
            .catch(WorldError.prism.disk.delete.review)
    }
}

public func readFile(at path: URL) -> WorldReader<WorldResult<Data>> {
    return .init { world in
        world.disk.read(from: path)
            .catch(WorldError.prism.disk.read.review)
    }
}

public func writeFile(to path: URL) -> (Data) -> WorldReader<WorldResult<Void>> {
    return { data in
        return .init { world in
            world.disk.write(data, to: path)
                .catch(WorldError.prism.disk.write.review)
        }
    }
}

public func copyFile(from source: URL, to destination: URL) -> WorldReader<WorldResult<Void>> {
    return readFile(at: source)
        >>>= writeFile(to: destination)
}

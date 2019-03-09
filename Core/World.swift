//
//  World.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public struct World {
    public let database: Database
    public let download: Downloader
    public let disk: Disk
    public let sync: Sync

    public init(
        database: Database,
        download: @escaping Downloader,
        disk: Disk,
        sync: @escaping Sync) {
        self.database = database
        self.download = download
        self.disk = disk
        self.sync = sync
    }
}

///sourcery:prism=chain
public enum WorldError {
    case database(FileIOError)
    case disk(FileIOError)
    case download(DownloadError)
}

public typealias WorldResult<T> = Result<T, WorldError>
public typealias WorldReader<T> = Reader<World, T>
public typealias WorldReaderEffect<T> = Effect<WorldReader<T>>
public typealias WorldInterpreter<T> = Interpreter<World, T>
public typealias WorldInterpreterRecorder<T> = InterpreterRecorder<World, T>
public typealias WorldReducer<S, A> = Reducer<S, A, World>
public typealias WorldStore<S, A> = Store<S, A, World>

public typealias WorldIO<T> = WorldReader<T>
public typealias WorldIOResult<T> = WorldIO<WorldResult<T>>

public func worldInterpreter<A>(world: World) -> WorldInterpreter<A> {
    return { effect, dispatch -> Void in
        func handle(effect: WorldReaderEffect<A>) {
            switch effect {
            case .background(let background):
                world.sync {
                    dispatch(background.apply(world))
                }
            case .main(let main):
                dispatch(main.apply(world))
            case .sequence(let sequence):
                sequence.forEach(handle)
            }
        }
        handle(effect: effect)
    }
}

public func >>>= <A, B>(a: WorldIOResult<A>, f: @escaping (A) -> WorldIOResult<B>) -> WorldIOResult<B> {
    return a.flatMap { result -> WorldIOResult<B> in
        switch result {
        case .success(let value): return f(value)
        case .failure(let error): return .pure(.failure(error))
        }
    }
}

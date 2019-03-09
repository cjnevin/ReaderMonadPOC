//
//  World.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core

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
public typealias WorldInterpreter<T> = Interpreter<World, T, WorldError>
public typealias WorldInterpreterRecorder<T> = InterpreterRecorder<World, T, WorldError>
public typealias WorldReducer<S, A> = Reducer<S, A, World, WorldError>
public typealias WorldStore<S, A> = Store<S, A, World, WorldError>
public typealias WorldObservable<T> = Observable<T, WorldError>

public typealias Recurring<T> = WorldReader<WorldObservable<T>>
public typealias ImmediateResult<T> = WorldReader<WorldResult<T>>

public func worldInterpreter<A>(world: World) -> WorldInterpreter<A> {
    return { method, dispatch -> Void in
        func immediate(_ effect: Effect<WorldReader<A>>) {
            switch effect {
            case .background(let background):
                world.sync {
                    dispatch(background.apply(world))
                }
            case .main(let main):
                dispatch(main.apply(world))
            case .sequence(let sequence):
                sequence.forEach(immediate)
            }
        }

        func recurring(_ effect: Effect<Recurring<A>>, disposable: CompositeDisposable) {
            switch effect {
            case .background(let background):
                world.sync {
                    disposable.add(background.apply(world).subscribe(onNext: dispatch))
                }
            case .main(let main):
                disposable.add(main.apply(world).subscribe(onNext: dispatch))
            case .sequence(let sequence):
                sequence.forEach { recurring($0, disposable: disposable) }
            }
        }

        switch method {
        case .immediate(let effect): immediate(effect)
        case .recurring(let effect, let disposable): recurring(effect, disposable: disposable)
        }
    }
}

public func >>>= <A, B>(a: ImmediateResult<A>, f: @escaping (A) -> ImmediateResult<B>) -> ImmediateResult<B> {
    return a.flatMap { result -> ImmediateResult<B> in
        switch result {
        case .success(let value): return f(value)
        case .failure(let error): return .pure(.failure(error))
        }
    }
}


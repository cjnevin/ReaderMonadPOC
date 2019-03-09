//
//  Try.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

/// Wraps do-try-catch logic
public enum Try<T> {
    case success(T)
    case failure(Error)

    public init(f: () throws -> T) {
        do {
            self = .success(try f())
        } catch {
            self = .failure(error)
        }
    }

    public enum TryError: Error {
        case throwError
    }
    public static func `throw`() -> Try<T> {
        return .init { throw TryError.throwError }
    }

    public var value: T? { if case .success(let t) = self { return t } else { return nil } }
    public var error: Error? { if case .failure(let e) = self { return e } else { return nil } }

    public func map<U>(_ f: @escaping (T) -> U) -> Try<U> {
        switch self {
        case .success(let value): return .success(f(value))
        case .failure(let error): return .failure(error)
        }
    }

    public func flatMap<U>(_ f: @escaping (T) -> Try<U>) -> Try<U> {
        switch self {
        case .success(let value): return f(value)
        case .failure(let error): return .failure(error)
        }
    }

    public func result<E>(_ f: @escaping (Error) -> E) -> Result<T, E> {
        switch self {
        case .success(let value): return .success(value)
        case .failure(let error): return .failure(f(error))
        }
    }

    public func result<E>(_ e: E) -> Result<T, E> {
        switch self {
        case .success(let value): return .success(value)
        case .failure: return .failure(e)
        }
    }
}

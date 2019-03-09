//
//  Result.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public enum Result<T, E> {
    public typealias Value = T
    public typealias Error = E

    case success(T)
    case failure(E)
}

extension Result {
    static func tryMake(success: T?, failure: E?) -> Result? {
        return success.map(Result.success) ?? failure.map(Result.failure)
    }

    func mapError<D>(_ f: @escaping (E) -> D) -> Result<T, D> {
        switch self {
        case .success(let value): return .success(value)
        case .failure(let error): return .failure(f(error))
        }
    }
    
    func map<U>(_ f: @escaping (T) -> U) -> Result<U, E> {
        switch self {
        case .success(let value): return .success(f(value))
        case .failure(let error): return .failure(error)
        }
    }

    func flatMap<U>(_ f: @escaping (T) -> Result<U, E>) -> Result<U, E> {
        switch self {
        case .success(let value): return f(value)
        case .failure(let error): return .failure(error)
        }
    }

    func flatMap<U>(_ f: @escaping (T) -> Result<U, E>?) -> Result<U, E>? {
        switch self {
        case .success(let value): return f(value)
        case .failure(let error): return .failure(error)
        }
    }

    func flatMapError<D>(_ f: @escaping (E) -> Result<T, D>) -> Result<T, D> {
        switch self {
        case .success(let value): return .success(value)
        case .failure(let error): return f(error)
        }
    }

    public func map<U>(_ f: @escaping (T) -> U) -> U? {
        switch self {
        case .success(let value): return f(value)
        case .failure: return nil
        }
    }
}

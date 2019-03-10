//
//  Signal.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public typealias ErrorlessSignal<T> = Signal<T, NoError>

public protocol SignalType {
    associatedtype T
    associatedtype E
    func subscribe<O: ObserverType>(observer: O) -> Disposable where O.T == T, O.E == E
}

public class Signal<T, E>: SignalType {
    private let subscribeHandler: (Observer<T, E>) -> Disposable

    public convenience init(_ elements: T...) {
        self.init { observer in
            elements.forEach(observer.next)
            observer.completed()
            return Indisposable()
        }
    }

    public init(_ subscriptionClosure: @escaping (Observer<T, E>) -> Disposable) {
        subscribeHandler = subscriptionClosure
    }

    public func subscribe<O : ObserverType>(observer: O) -> Disposable where O.T == T, O.E == E {
        let sink = Sink(forward: observer, subscriptionHandler: subscribeHandler)
        sink.run()
        return sink
    }
}

extension SignalType {
    public func noError() -> Signal<T, NoError> {
        return mapError { _ in NoError() }
    }
}

extension SignalType {
    public static func error(_ error: E) -> Signal<T, E> {
        return Signal { observer in
            observer.error(error)
            return Indisposable()
        }
    }

    public static func just(_ elements: T...) -> Signal<T, E> {
        return Signal { observer in
            elements.forEach(observer.next)
            observer.completed()
            return Indisposable()
        }
    }

    public func subscribe(onNext: @escaping (T) -> Void) -> Disposable {
        return subscribe(observer: Observer { event in
            if case .next(let element) = event {
                onNext(element)
            }
        })
    }

    public func mapError<F>(_ transform: @escaping (E) -> F) -> Signal<T, F> {
        return Signal<T, F> { observer in
            return self.subscribe(observer: Observer { event in
                switch event {
                case .next(let element):
                    observer.next(element)
                case .error(let error):
                    observer.error(transform(error))
                case .completed:
                    observer.completed()
                }
            })
        }
    }

    public func map<U>(_ transform: @escaping (T) -> U) -> Signal<U, E> {
        return Signal<U, E> { observer in
            return self.subscribe(observer: Observer { event in
                switch event {
                case .next(let element):
                    observer.next(transform(element))
                case .error(let error):
                    observer.error(error)
                case .completed:
                    observer.completed()
                }
            })
        }
    }

    public func flatMap<U>(_ transform: @escaping (T) -> Signal<U, E>) -> Signal<U, E> {
        return Signal { observer -> Disposable in
            return self.subscribe(observer: Observer { event in
                let composite = CompositeDisposable()
                let error: (E) -> Void = { e in observer.error(e); composite.dispose() }
                let complete = { observer.completed(); composite.dispose() }
                switch event {
                case .next(let element):
                    composite += transform(element).subscribe(observer: Observer { transformedEvent in
                        switch transformedEvent {
                        case .next(let element): observer.next(element)
                        case .error(let e): error(e)
                        case .completed: complete()
                        }
                    })
                case .error(let e): error(e)
                case .completed: complete()
                }
            })
        }
    }

    public func map<U>(_ keyPath: KeyPath<T, U>) -> Signal<U, E> {
        return map { $0[keyPath: keyPath] }
    }

    public func filter(_ predicate: @escaping (T) -> Bool) -> Signal<T, E> {
        return Signal<T, E> { observer in
            return self.subscribe(observer: Observer { event in
                switch event {
                case .next(let element):
                    if predicate(element) {
                        observer.next(element)
                    }
                case .error(let error):
                    observer.error(error)
                case .completed:
                    observer.completed()
                }
            })
        }
    }

    public static func merge<U: SignalType>(_ observables: [U]) -> Signal<U.T, U.E>  {
        return Signal<U.T, U.E> { observer in
            var completed: Bool = false
            var error: U.E? = nil
            let disposable = observables.map { observable in
                observable.subscribe(observer: Observer { event in
                    switch event {
                    case .next(let element): observer.next(element)
                    case .error(let nextError):
                        if error == nil {
                            error = nextError
                        }
                    case .completed:
                        completed = true
                    }
                })
            }.reduce(CompositeDisposable(), +)
            if let error = error {
                observer.error(error)
            } else if completed {
                observer.completed()
            }
            return disposable
        }
    }
}

extension Sequence where Element: SignalType {
    public func merge() -> Signal<Element.T, Element.E> {
        return .merge(Array(self))
    }
}

extension SignalType where T: OptionalType {
    public func filterNil() -> Signal<T.Wrapped, E> {
        return filter { ($0 as? T.Wrapped) != nil }.map { $0 as! T.Wrapped }
    }
}

extension SignalType where T == Bool {
    public func `true`() -> Signal<T, E> {
        return filter { $0 == true }
    }

    public func `false`() -> Signal<T, E> {
        return filter { !$0 }
    }
}

extension SignalType where T: Equatable {
    public func equalTo(_ element: T) -> Signal<T, E> {
        return filter { $0 == element }
    }

    public func notEqualTo(_ element: T) -> Signal<T, E> {
        return filter { $0 != element }
    }
}

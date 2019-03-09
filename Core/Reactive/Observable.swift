//
//  Observable.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public protocol ObservableType {
    associatedtype T
    associatedtype E
    func subscribe<O: ObserverType>(observer: O) -> Disposable where O.T == T, O.E == E
}

public class Observable<T, E>: ObservableType {
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

extension ObservableType {
    public func noError() -> Observable<T, NoError> {
        return mapError { _ in NoError() }
    }
}

extension ObservableType {
    public static func error(_ error: E) -> Observable<T, E> {
        return Observable { observer in
            observer.error(error)
            return Indisposable()
        }
    }

    public static func just(_ elements: T...) -> Observable<T, E> {
        return Observable { observer in
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

    public func mapError<F>(_ transform: @escaping (E) -> F) -> Observable<T, F> {
        return Observable<T, F> { observer in
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

    public func map<U>(_ transform: @escaping (T) -> U) -> Observable<U, E> {
        return Observable<U, E> { observer in
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

    public func flatMap<U>(_ transform: @escaping (T) -> Observable<U, E>) -> Observable<U, E> {
        return Observable { observer -> Disposable in
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

    public func map<U>(_ keyPath: KeyPath<T, U>) -> Observable<U, E> {
        return map { $0[keyPath: keyPath] }
    }

    public func filter(_ predicate: @escaping (T) -> Bool) -> Observable<T, E> {
        return Observable<T, E> { observer in
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

    public static func merge<U: ObservableType>(_ observables: [U]) -> Observable<U.T, U.E>  {
        return Observable<U.T, U.E> { observer in
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

extension Sequence where Element: ObservableType {
    public func merge() -> Observable<Element.T, Element.E> {
        return .merge(Array(self))
    }
}

extension ObservableType where T: OptionalType {
    public func filterNil() -> Observable<T.Wrapped, E> {
        return filter { ($0 as? T.Wrapped) != nil }.map { $0 as! T.Wrapped }
    }
}

extension ObservableType where T == Bool {
    public func `true`() -> Observable<T, E> {
        return filter { $0 == true }
    }

    public func `false`() -> Observable<T, E> {
        return filter { !$0 }
    }
}

extension ObservableType where T: Equatable {
    public func equalTo(_ element: T) -> Observable<T, E> {
        return filter { $0 == element }
    }

    public func notEqualTo(_ element: T) -> Observable<T, E> {
        return filter { $0 != element }
    }
}

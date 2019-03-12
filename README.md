# Reader Monad POC
Proof of concept using reader monad, redux, and snapshot tests.

## Reader Monad
The Reader monad allows us to abstract all dependency injection in our application to a single point (known as a `World`). We can then inject a different `World` in order to run unit or automation tests (or different configurations).

For example:
* A `Debug World` may log every event that goes through the system, to help us debug. 
* A `Unit Test World` may record all events and move all asynchronous tasks to the main thread to allow the tests to be executed synchronously. 
* An `Automation World` may configure a mock API instead of the default API.

## Redux
Redux allows us to control when the global state of the application can change and when side-effects can occur. 

It (and other unidirectional architectures) are a fundamental part in making applications safe by reducing the potential for dead-locks and race-conditions practically to zero (if you implement it correctly).

Read more: https://itnext.io/functional-architecture-e9031090ff18

## Synchronicity

Monads can be chained to perform **synchronous** tasks which can then be executed on a background thread. These are essentially using an idea like co-routines to reduce complexity throughout the chain by converting asynchronous operations into synchronous operations.

Asynchronous tasks are confined to the App as it's considered a side-effect in this architecture. However, we can still use them for returned values (as sometimes UI will require multiple updates of a value over time), they will be dispatched by the given `sync` closure in `World` to determine where to execute. To make them testable out of the box we must pass in an immediate callback.

## Snapshot Tests
Snapshot will be used to compare the previous recorded state with the current in memory state. Tests will fail if they do not match.

These tests run synchronously, so we can test an entire flow such as login in a single `assert`.

You can run in both `record` mode and `play` mode. Record will dump what you should store in a file which will be used each time that test is run. 

I have implemented a rudimentary version which works for simple data types.

There is a nicer version available here: https://github.com/pointfreeco/swift-snapshot-testing

**Make sure you review the file to ensure logic is what you expect.**

## Tests
Tests live with their counterparts, same folder they just belong to the test target instead.

Why? Read: https://kickstarter.engineering/why-you-should-co-locate-your-xcode-tests-c69f79211411

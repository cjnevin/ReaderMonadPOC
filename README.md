# IOMonadPOC
Proof of concept using IO monad, redux, and snapshot tests

## IOMonad
The IO monad allows us to abstract all dependency injection in our application to a single point (known as a 'World' or 'Environment'). We can then inject a different 'World' in order to run unit or automation tests (or different configurations).

For example, a 'Debug World' may log every event that goes through the system, to help us debug. A 'Unit Test World' may record all events and move all asynchronous tasks to the main thread to allow the tests to be executed synchronously.

## Redux
Redux allows us to control when the global state of the application can change and when side-effects can occur. 

It (and other unidirectional architectures) are a fundamental part in making applications safe by reducing the potential for dead-locks and race-conditions practically to zero (if you implement it correctly).

## Snapshot Tests
Snapshot will be used to compare the previous recorded state with the current in memory state. Tests will fail if they do not match.

You can run in both `record` mode and `play` mode. Record will dump what you should store in a file which will be used each time that test is run. 

**Make sure you review the file to ensure logic is what you expect.**

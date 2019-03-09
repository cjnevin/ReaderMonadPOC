//
//  WorldStoreTest.swift
//  POCTests
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import XCTest
import Core
import World
@testable import POC

enum RecordMode {
    /// Compare files stored
    case play
    /// Replace existing files
    case record
}

/// In order to support different versions in the future without needing to go back and retrospectively fix old versions
/// we should specify the version we want the subclass to use.
enum OutputSpecVersion {
    case one

    func output<T: Recorder>(_ recorder: T, events: [Any], to outputRecorder: inout OutputRecorder) {
        if events.isEmpty { return }
        print("\(recorder)", to: &outputRecorder)
        dump(events, to: &outputRecorder)
    }
}

class WorldStoreTest: XCTestCase {
    var recordMode: RecordMode = .play
    var outputSpecVersion: OutputSpecVersion = .one

    var store: Store<AppState, AppAction, World, WorldError>!
    var world: World!

    var outputRecorder: OutputRecorder!

    var testableStore = TestableWorldStore()
    var testableWorld = TestableWorld()

    override func setUp() {
        super.setUp()
        world = testableWorld.makeWorld()
        store = testableStore.makeStore(world: world)
        outputRecorder = OutputRecorder()
    }

    func testRecordModeOff() {
        if type(of: self) == WorldStoreTest.self {
            XCTAssert(recordMode == .play)
        }
    }

    func assert(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        XCTAssert(type(of: self) != WorldStoreTest.self)
        outputAll(reducerEvents: [])
        finalise(file: file, function: function, line: line)
    }

    func assert<T>(keyPath: KeyPath<AppState, T>, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        XCTAssert(type(of: self) != WorldStoreTest.self)
        outputAll(reducerEvents: testableStore.reducerRecorder[keyPath])
        finalise(file: file, function: function, line: line)
    }

    func assert<T, U>(keyPaths keyPath1: KeyPath<AppState, T>, _ keyPath2: KeyPath<AppState, U>, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        XCTAssert(type(of: self) != WorldStoreTest.self)
        outputAll(reducerEvents: testableStore.reducerRecorder[keyPath1, keyPath2])
        finalise(file: file, function: function, line: line)
    }

    func assert<T, U, V>(keyPaths keyPath1: KeyPath<AppState, T>, _ keyPath2: KeyPath<AppState, U>, _ keyPath3: KeyPath<AppState, V>, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        XCTAssert(type(of: self) != WorldStoreTest.self)
        outputAll(reducerEvents: testableStore.reducerRecorder[keyPath1, keyPath2, keyPath3])
        finalise(file: file, function: function, line: line)
    }

    private func output<T: Recorder>(_ recorder: T, events: [Any] = []) {
        outputSpecVersion.output(recorder, events: events.isEmpty ? recorder.events : events, to: &outputRecorder)
    }

    private func outputAll(reducerEvents: [Any]) {
        output(testableWorld.databaseRecorder)
        output(testableWorld.diskRecorder)
        output(testableWorld.downloadRecorder)
        output(testableStore.reducerRecorder, events: reducerEvents)
    }

    private func finalise(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let url = URL(fileURLWithPath: "\(file)")
        let name = "\(url.lastPathComponent.components(separatedBy: ".swift")[0].alphaNumericOnly())_\(function.alphaNumericOnly())"
        let ext = "record"

        if recordMode == .record {
            print("\n!!!! Copy the below into a file called: \(name).\(ext) !!!!\n\n")
            print(outputRecorder.result)
            print("\n\n!!!! Copy the above into a file called: \(name).\(ext) !!!!\n")
            XCTFail("Please disable recordMode once you have generated output")
        } else {
            let path = Bundle(for: WorldStoreTest.self).path(forResource: name, ofType: ext)!
            let content = try! String(contentsOfFile: path).trimmingCharacters(in: .whitespacesAndNewlines)
            XCTAssertEqual(outputRecorder.result, content, file: file, line: line)
        }
    }
}

private extension StaticString {
    func alphaNumericOnly() -> String {
        return "\(self)".alphaNumericOnly()
    }
}

private extension String {
    func alphaNumericOnly() -> String {
        return components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }
}

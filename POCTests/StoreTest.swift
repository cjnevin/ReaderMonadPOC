//
//  StoreTest.swift
//  POCTests
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import XCTest
import Core
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

class StoreTest: XCTestCase {
    var recordMode: RecordMode = .play
    var outputSpecVersion: OutputSpecVersion = .one

    var database = TestableDatabase(MemoryDatabase())
    var databaseRecorder: DatabaseRecorder!

    var downloadResult: Download = Download.failure(.unknown)
    var downloadRecorder: DownloadRecorder!

    var disk: Disk = MemoryDisk()
    var diskRecorder: DiskRecorder!

    var reducer: Reducer<AppState, AppAction, World>! = appReducer
    var reducerRecorder: ReducerRecorder<AppState, AppAction, World>!

    var store: Store<AppState, AppAction, World>!

    var sync: Sync = mainSync

    var outputRecorder: OutputRecorder!

    var world: World!
    var interpreter: WorldInterpreter<AppAction>!

    override func setUp() {
        super.setUp()
        reducerRecorder = ReducerRecorder(reducer: reducer)
        downloadRecorder = DownloadRecorder { _ in self.downloadResult }
        diskRecorder = DiskRecorder(disk)
        databaseRecorder = DatabaseRecorder(database)

        world = World(
            database: databaseRecorder,
            download: downloadRecorder.downloader,
            disk: diskRecorder,
            sync: sync)
        interpreter = worldInterpreter(world: world)

        store = Store(
            reducer: reducerRecorder.reducer,
            interpreter: interpreter,
            initialState: AppState())

        outputRecorder = OutputRecorder()
    }

    func testRecordModeOff() {
        if type(of: self) == StoreTest.self {
            XCTAssert(recordMode == .play)
        }
    }

    func assert(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        XCTAssert(type(of: self) != StoreTest.self)

        output(databaseRecorder)
        output(diskRecorder)
        output(downloadRecorder)
        output(reducerRecorder)

        finalise(file: file, function: function, line: line)
    }

    func assert<T>(keyPath: KeyPath<AppState, T>, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        XCTAssert(type(of: self) != StoreTest.self)

        output(databaseRecorder)
        output(diskRecorder)
        output(downloadRecorder)
        output(reducerRecorder, events: reducerRecorder[keyPath])

        finalise(file: file, function: function, line: line)
    }

    private func output<T: Recorder>(_ recorder: T, events: [Any] = []) {
        outputSpecVersion.output(recorder, events: events.isEmpty ? recorder.events : events, to: &outputRecorder)
    }

    private func finalise(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let url = URL(fileURLWithPath: "\(file)")
        let name = "\(url.lastPathComponent.components(separatedBy: ".swift")[0].alphaNumericOnly())_\(function.alphaNumericOnly())"
        let ext = "record"

        if recordMode == .record {
            print("\n!!!! Copy the below into a file called: \(name).\(ext) !!!!\n\n")
            print(outputRecorder.result)
            print("\n\n!!!! Copy the above into a file called: \(name).\(ext) !!!!\n")
        } else {
            let path = Bundle(for: StoreTest.self).path(forResource: name, ofType: ext)!
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

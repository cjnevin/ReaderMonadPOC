//
//  FileManagerTests.swift
//  Core
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

class FileManagerDiskTests: DiskTests {
    override func setUp() {
        super.setUp()
        self.sut = FileManager.default
        self.path = temporaryFileURL()
    }

    func temporaryFileURL() -> URL {
        let directory = NSTemporaryDirectory()
        let filename = UUID().uuidString
        let fileURL = URL(fileURLWithPath: directory).appendingPathComponent(filename)
        addTeardownBlock {
            do {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: fileURL.path) {
                    try fileManager.removeItem(at: fileURL)
                    XCTAssertFalse(fileManager.fileExists(atPath: fileURL.path))
                }
            } catch {
                XCTFail("Error while deleting temporary file: \(error)")
            }
        }
        return fileURL
    }
}

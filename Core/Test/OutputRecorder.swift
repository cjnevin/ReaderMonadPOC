//
//  OutputRecorder.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public struct OutputRecorder: TextOutputStream {
    private var current: String = ""
    private var written: [String] = []
    public var result: String {
        return written.joined(separator: "\n")
    }

    public init() { }
    public mutating func write(_ string: String) {
        if string == "\n" {
            written.append(current.stripLLDBExpressions())
            current = ""
        } else {
            current += string
        }
    }

    public func save(to path: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let url = URL(fileURLWithPath: path)
        let name = "\(url.lastPathComponent.alphaNumericOnly())_\(function.alphaNumericOnly()).record"
        try! FileManager().createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        let filePath = url.appendingPathComponent(name).absoluteString
        print("Saved file to: \(filePath)")
        try! result.write(toFile: filePath, atomically: true, encoding: .utf8)
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

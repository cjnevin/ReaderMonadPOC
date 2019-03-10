//
//  String+Output.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

private let lldbExpressionRegex = try! NSRegularExpression(pattern: "__lldb_expr_\\w*.", options: NSRegularExpression.Options.caseInsensitive)

extension String {
    func stripLLDBExpressions() -> String {
        return lldbExpressionRegex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length:  count), withTemplate: "")
    }

    func strip(_ text: String) -> String {
        return replacingOccurrences(of: text, with: "")
    }

    func stripCorePrefix() -> String {
        return strip("Core.")
    }

    func stripWorldPrefix() -> String {
        return strip("World.")
    }

    func stripPOCPrefix() -> String {
        return strip("POC.")
    }

    func stripCruft() -> String {
        return stripLLDBExpressions()
            .stripPOCPrefix()
            .stripCorePrefix()
            .stripWorldPrefix()
    }
}

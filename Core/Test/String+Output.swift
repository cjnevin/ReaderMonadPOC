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
}

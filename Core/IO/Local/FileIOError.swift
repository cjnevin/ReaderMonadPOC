//
//  Error.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

///sourcery:prism=chain
public enum ReadError { case notReadable, notFound }
///sourcery:prism=chain
public enum WriteError { case notWritable }
///sourcery:prism=chain
public enum DeleteError { case notDeletable }

///sourcery:prism=chain
public enum FileIOError {
    case delete(DeleteError)
    case read(ReadError)
    case write(WriteError)
}

//
//  Error.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public enum ReadError { case notFound }
public enum WriteError { case notWritable }
public enum DeleteError { case notDeletable }

public enum FileIOError {
    case delete(DeleteError)
    case read(ReadError)
    case write(WriteError)
}

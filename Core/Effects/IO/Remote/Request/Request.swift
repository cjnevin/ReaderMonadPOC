//
//  Request.swift
//  Core
//
//  Created by Chris Nevin on 12/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

public typealias Response = Result<Data, NetworkIOError>
public typealias RequestExecutor = (URLRequest) -> Response

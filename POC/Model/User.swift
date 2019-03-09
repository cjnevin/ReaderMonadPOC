
//
//  User.swift
//  POC
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import RealmSwift

struct User: Comparable, ModelType {
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.name < rhs.name
    }

    let id: String
    let name: String

    func asRealm() -> UserObject {
        let o = UserObject()
        o.id = id
        o.name = name
        return o
    }
}

final class UserObject: Object, RealmType {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""

    override public class func primaryKey() -> String? {
        return #keyPath(id)
    }

    func asModel() -> User {
        return User(id: id, name: name)
    }
}

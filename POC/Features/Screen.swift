//
//  Screen.swift
//  POC
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import World

enum Screen: String, Hashable {
    case userList
    case userDetails
}

extension Screen {
    func make() -> UIViewController {
        switch self {
        case .userDetails: return UserDetailsViewController(screen: self)
        case .userList: return UserListViewController(screen: self)
        }
    }
}

func navigate(to screen: Screen) -> WorldReader<Void> {
    return navigate(to: screen.rawValue)
}

func navigate(to screen: String) -> Void {
    guard let _screen = Screen(rawValue: screen) else {
        assertionFailure("Cannot navigate to screen: \(screen)")
        return
    }
    UIApplication.shared.keyWindow?.rootViewController?.topViewController.navigate(to: _screen)
}

extension UIViewController {
    var topViewController: UIViewController {
        if let selectedViewController = (self as? UITabBarController)?.selectedViewController {
            return selectedViewController.topViewController
        }
        if let topViewController = (self as? UINavigationController)?.topViewController {
            return topViewController.topViewController
        }
        return presentedViewController?.topViewController ?? self
    }

    func navigate(to screen: Screen) {
        switch screen {
        case .userList: navigationController?.popToRootViewController(animated: true)
        case .userDetails: navigationController?.pushViewController(screen.make(), animated: true)
        }
    }
}

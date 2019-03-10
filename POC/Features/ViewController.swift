//
//  ViewController.swift
//  POC
//
//  Created by Chris Nevin on 10/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import UIKit
import Render

class ViewController: UIViewController {
    let screen: Screen

    init(screen: Screen) {
        self.screen = screen
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.dispatch(.screen(screen))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unbind()
    }
}

extension ViewController {
    func subscribe<T>(to keyPath: KeyPath<AppState, T>, callback: @escaping (T) -> Void) {
        store.subscribe(screen, to: keyPath, callback: callback)
    }

    @objc func bind() {

    }

    @objc func unbind() {
        dispose(screen: screen)
    }
}

//
//  LoadableViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-26.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

open class LoadableViewController: UIViewController {

    public let loadingView = LoadingView()
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        self.addChild(loadingView)
        self.view.addSubview(loadingView.view)
        self.view.constrainSubviewToBounds(loadingView.view)
        self.view.bringSubviewToFront(loadingView.view)
    }
}

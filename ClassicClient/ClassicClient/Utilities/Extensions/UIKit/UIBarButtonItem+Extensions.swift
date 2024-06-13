//
//  UIBarButtonItem+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-06-07.
//

import UIKit

public class BarButtonItemHandler: NSObject {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    @objc func handleAction() {
        action()
    }
}

public extension UIBarButtonItem {
    private struct AssociatedKeys {
        static var handlerKey = "handlerKey"
    }

    private var handler: BarButtonItemHandler? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.handlerKey) as? BarButtonItemHandler
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.handlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    convenience init(title: String?, style: UIBarButtonItem.Style, action: @escaping () -> Void) {
        let handler = BarButtonItemHandler(action: action)
        self.init(title: title, style: style, target: handler, action: #selector(BarButtonItemHandler.handleAction))
        self.handler = handler
    }

    convenience init(image: UIImage?, style: UIBarButtonItem.Style, action: @escaping () -> Void) {
        let handler = BarButtonItemHandler(action: action)
        self.init(image: image, style: style, target: handler, action: #selector(BarButtonItemHandler.handleAction))
        self.handler = handler
    }
}

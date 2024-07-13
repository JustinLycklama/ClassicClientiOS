//
//  Textfield+Extension.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-07-03.
//

import Foundation

public extension UITextField {
    
    /// Returns text in textField at time of action
    func addToobarDone(onCancel: ((String?) -> Void)?, onDone: ((String?) -> Void)?) {
        let toolbar = DoneToolbar(associatedTextField: self, onCancel: onCancel, onDone: onDone)
        inputAccessoryView = toolbar
    }
}

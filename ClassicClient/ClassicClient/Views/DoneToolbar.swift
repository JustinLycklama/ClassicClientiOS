//
//  DoneToolbar.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-07-03.
//

import UIKit

class DoneToolbar: UIToolbar {
    
    private let onCancel: ((String?) -> Void)?
    private let onDone: ((String?) -> Void)?
    
    private let associatedTextField: UITextField
    
    init(associatedTextField: UITextField, onCancel: ((String?) -> Void)?, onDone: ((String?) -> Void)?) {
        self.associatedTextField = associatedTextField
        
        self.onCancel = onCancel
        self.onDone = onDone
        
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        barStyle = .default
        items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelkeyBoard)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donekeyboard))]
        sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancelkeyBoard() {
        self.associatedTextField.endEditing(true)
        onCancel?(associatedTextField.text)
    }
    
    @objc func donekeyboard() {
        self.associatedTextField.endEditing(true)
        onDone?(associatedTextField.text)
    }
}

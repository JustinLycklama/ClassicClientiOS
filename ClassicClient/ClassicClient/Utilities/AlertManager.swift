//
//  AlertManager.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-26.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import Foundation

public class AlertManager {
    
    public static let shared = AlertManager()
    private init() {}
    
    public func displayMessage(_ message: String? = nil, _ error: Error? = nil, completion: (() -> Void)? = nil) {
        var text = message
        if let error {
            if text?.count ?? 0 > 0 {
                text?.append("\n")
            }
            
            if let serviceError = error as? ServiceError {
                switch serviceError {
                case .couldNotParseURL:
                    text?.append("Could not parse URL")
                case .failedInTransport(let transportError):
                    text?.append(transportError.localizedDescription)
                case .failedWithMessage(let message):
                    text?.append(message)
                case .unableToDecodeResponse:
                    text?.append("Unable to decode response")
                }
            } else {
                text?.append(error.localizedDescription)
            }
        }
        
        let alert = UIAlertController.init(title: "Biiibo", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .cancel) { (action) in
            completion?()
        }
        
        alert.addAction(okAction)
        presentAlert(alert)
    }
    
    public func displayQuestion(_ message: String, onOkay: @escaping (() -> Void), onCancel: (() -> Void)? = nil) {
        let alert = UIAlertController.init(title: "Biiibo", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            onOkay()
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            onCancel?()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        presentAlert(alert)
    }
    
    public func displayTextfield(_ title: String? = nil,
                          placeholder: String? = nil,
                          maxCharacters: Int? = nil,
                          completion: ((String?) -> Void)? = nil) {
        
        var maxCharsDelegate: TextFieldMaxCharDelegate?
        if let maxCharacters {
            maxCharsDelegate = TextFieldMaxCharDelegate(maxCharacters)
        }
        
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            completion?(alert.textFields?.first?.text)
            maxCharsDelegate = nil // Hold reference so delegate continues to exist
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            completion?(nil)
        }
        
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
            newTextField.delegate = maxCharsDelegate
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        presentAlert(alert)
    }
    
    public func presentAlert(_ alert: UIAlertController) {
        DispatchQueue.main.async { [weak self] in
            self?.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Private
    
    private func rootViewController() -> UIViewController? {
        return UIApplication.shared.delegate?.window??.rootViewController
    }
    
    private func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        var controller = controller
        if controller == nil {
            controller = rootViewController()
        }
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}

class TextFieldMaxCharDelegate: NSObject, UITextFieldDelegate {
    let maxChars: Int
    
    init(_ maxChars: Int) {
        self.maxChars = maxChars
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText: String?
        
        if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
            newText = textFieldString.replacingCharacters(in: swtRange, with: string)
        } else {
            newText = nil
        }
        
        // We should disallow going above the limit, or if the limit was already somehow broken, allow deletions
        return newText?.count ?? 0 <= maxChars || (newText?.count ?? 0 < textField.text?.count ?? 0)
    }
}

// MARK: DuplicatableViewController

protocol DuplicatableViewController: AnyObject {
    func duplicate() -> UIViewController
}

extension UIAlertController: DuplicatableViewController {
    func duplicate() -> UIViewController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for action in actions {
            alert.addAction(action)
        }
        
        return alert
    }
}

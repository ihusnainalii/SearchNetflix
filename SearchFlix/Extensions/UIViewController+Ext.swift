//
//  UIViewController+Ext.swift
//  SearchFlix
//
//  Created by Husnian Ali on 20.02.2025.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "Error", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        DispatchQueue.performOnMainThread {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

//
//  Alert+ViewController.swift
//  SurveyApp
//
//  Created by sanad barjawi on 03/04/2022.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(actionOK)
        self.present(alert, animated: true)
    }
}

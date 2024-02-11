//
//  BaseViewController.swift
//  MangomoloTask
//
//  Created by Karim Ezzedine on 09/02/2024.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    }
    
    //NOTE:
    /// Any initial and common styling will be implemented in this method
    func setupInterface() {
        self.view.backgroundColor = .customNavyBlue
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

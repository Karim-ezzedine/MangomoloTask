//
//  CheckBoxButton.swift
//  MangomoloTask
//
//  Created by Karim Ezzedine on 09/02/2024.
//

import UIKit

class CheckBoxButton: BaseButton {
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    //MARK: - Setup
    
    override func setupView() {
        super.setupView()
        setTitle("", for: .normal)
        
        view.backgroundColor = UIColor.customOrange
        view.layer.cornerRadius = 12
        
        checkBoxImageView.tintColor = UIColor.customWhite
        
        captionLabel.textColor = UIColor.customWhite
        captionLabel.font = UIFont.getMediumFont(size: 19)
        
        text = ""
        
        addCustomConstraint()
    }
    
    func addCustomConstraint() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*0.064)
        ])
    }
    
    //MARK: - Computed Properties
    
    var text: String = "" {
        didSet {
            self.captionLabel.text = text
        }
    }
    
    var isCheckBoxSelected: Bool = false {
        didSet {
            checkBoxImageView.image = UIImage(systemName: isCheckBoxSelected ? "checkmark.square.fill" : "square")
        }
    }
}

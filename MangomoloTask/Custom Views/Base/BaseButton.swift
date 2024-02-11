//
//  BaseButton.swift
//  MangomoloTask
//
//  Created by Karim Ezzedine on 09/02/2024.
//

import UIKit

class BaseButton: UIButton {
    
    // MARK: - UIView
    
    @IBOutlet weak var view: UIView!
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }
    
    // MARK: - Overriden Methods
    
    override func embeddedView() -> UIView? {
        return view
    }
    
}

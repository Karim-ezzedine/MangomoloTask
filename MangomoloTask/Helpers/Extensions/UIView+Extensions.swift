//
//  UIView+Extensions.swift
//  MangomoloTask
//
//  Created by Karim Ezzedine on 09/02/2024.
//

import UIKit

extension UIView {
    func xibSetup() {
        
        let bundle = Bundle(for: type(of: self))
        let fileName = self.typeName
        
        if bundle.path(forResource: fileName, ofType: "nib") != nil {
            bundle.loadNibNamed(fileName, owner: self, options: nil)
        }
        
        if let view = embeddedView() {
            view.frame = self.bounds
            addAutoLayoutSubview(view)
        }
        
        setupView()
    }
    
    @objc func setupView() {
    }
    
    @objc func embeddedView() -> UIView? {
        return nil
    }
    
    func addAutoLayoutSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        var anchors = [NSLayoutConstraint]()
        anchors.append(topAnchor.constraint(equalTo: subview.topAnchor, constant: 0))
        anchors.append(bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 0))
        anchors.append(leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 0))
        anchors.append(trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: 0))
        NSLayoutConstraint.activate(anchors)
    }
}

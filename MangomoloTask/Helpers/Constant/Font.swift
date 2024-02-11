//
//  Font.swift
//  MangomoloTask
//
//  Created by Karim Ezzedine on 09/02/2024.
//

import UIKit

extension UIFont {
    static func getBoldFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNext-Bold", size: size)
    }
    
    static func getMediumFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNext-Medium", size: size)
    }
    
    static func getRegularFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNext-Regular", size: size)
    }
}

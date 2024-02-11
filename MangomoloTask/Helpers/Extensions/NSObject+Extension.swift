//
//  NSObject+Extension.swift
//  MangomoloTask
//
//  Created by Karim Ezzedine on 09/02/2024.
//

import Foundation

extension NSObject {
    static var typeName: String {
        return String(describing: self)
    }
    
    var typeName: String {
        let thisType = type(of: self)
        return String(describing: thisType)
    }
}

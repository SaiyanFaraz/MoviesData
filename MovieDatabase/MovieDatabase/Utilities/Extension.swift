//
//  Extension.swift
//  MovieDatabase
//
//  Created by Shabuddin SA on 14/10/24.
//

import Foundation
import UIKit

extension Array where Element: Hashable {
    func unique() -> [Element] {
        return Array(Set(self))
    }
    
}

extension UIView {
    func setAnchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil,
                   bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil,
                   paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0,
                   paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0,
                   width: CGFloat = 0, height: CGFloat = 0){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inview view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inview view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, rightAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0, paddingRight: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = !translatesAutoresizingMaskIntoConstraints
        
        if let left = leftAnchor {
            setAnchor(left: left, paddingLeft: paddingLeft)
        }
        if let right = rightAnchor {
            setAnchor(right: right, paddingRight: paddingRight)
        }
    }
}

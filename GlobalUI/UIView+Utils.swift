//
//  UIView+Utils.swift
//  GlobalUI
//
//

import UIKit

public extension UIView {
    static var useConstraint: Self {
        let view = Self()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    var useConstraint: Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func add(subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}

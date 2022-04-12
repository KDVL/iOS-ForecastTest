//
//  UIViewController+SwiftUI.swift
//  GlobalUI
//
//

import Foundation
import SwiftUI

extension UIViewController {
    public func addFullScreenView<Content: View>(_ view: Content) {
        let childView = UIHostingController(rootView: view)
        childView.view.invalidateIntrinsicContentSize()
        addChild(childView)
        childView.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(childView.view)
        NSLayoutConstraint.activate([
            childView.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            childView.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            childView.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            childView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        childView.didMove(toParent: self)

    }
}

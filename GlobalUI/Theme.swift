//
//  Theme.swift
//  GlobalUI
//
//

import UIKit
import Foundation

public struct Theme {
    /// Setup appearances for the application components.
    public static func setup() {
        styleNavigationBar()
    }
}

private extension Theme {
    static func styleNavigationBar() {
        let appearance = UINavigationBarAppearance()

        appearance.backgroundColor = GlobalColor.backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

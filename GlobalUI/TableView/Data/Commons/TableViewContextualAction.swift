//
//  TableViewAction.swift
//  GlobalUI
//
//

import UIKit

public class TableViewContextualAction {
    let style: UIContextualAction.Style
    let title: String?
    let image: UIImage?
    let backgroundColor: UIColor
    let action: ((TableViewData) -> Void)?
    
    public init(title: String? = nil, image: UIImage? = nil, style: UIContextualAction.Style = .normal,
                backgroundColor: UIColor, action: ((TableViewData) -> Void)?) {
        self.title = title
        self.action = action
        self.image = image
        self.style = style
        self.backgroundColor = backgroundColor
    }
}

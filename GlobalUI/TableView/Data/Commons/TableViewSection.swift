//
//  TableViewSection.swift
//  GlobalUI
//
//

import UIKit

open class TableViewSection: Hashable {
    var identifier: String = UUID().uuidString
    public var datas: [TableViewData] = []

    var backgroundColor: UIColor = .white
    var separator: TableViewSeparator = .none
    var separatorColor: UIColor = .separator
    var margin = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)

    var sectionType: TableViewSectionView.Type? { nil }

    public init(identifier: String = UUID().uuidString, datas: [TableViewData] = []) {
        self.identifier = identifier
        self.datas = datas
    }

    public static func == (lhs: TableViewSection, rhs: TableViewSection) -> Bool { lhs.isEqual(to: rhs) }
    public func isEqual(to other: TableViewSection) -> Bool { identifier == other.identifier }
    public func hash(into hasher: inout Hasher) {
        // To override
    }
}

public extension TableViewSection {
    @discardableResult
    func set(backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }

    @discardableResult
    func set(separator: TableViewSeparator) -> Self {
        self.separator = separator
        return self
    }

    @discardableResult
    func set(separatorColor: UIColor) -> Self {
        self.separatorColor = separatorColor
        return self
    }

    @discardableResult
    func set(margin: UIEdgeInsets) -> Self {
        self.margin = margin
        return self
    }

    @discardableResult
    func set(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> Self {
        set(margin: UIEdgeInsets(top: top ?? margin.top, left: left ?? margin.left,
                                 bottom: bottom ?? margin.bottom, right: right ?? margin.right))
    }
}

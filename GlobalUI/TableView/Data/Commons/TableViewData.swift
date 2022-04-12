//
//  TableViewData.swift
//  GlobalUI
//
//

import UIKit

public enum TableViewSeparator {
    case full
    case none
    case custom(left: CGFloat, right: CGFloat)
}

open class TableViewData {
    var cellIdentifier: String { String(describing: type(of: self)) }
    open var cellType: TableViewCell.Type? { nil }

    public var accessory: UITableViewCell.AccessoryType = .none
    public var backgroundColor: UIColor = .clear
    public var isSelectable: Bool = true
    public var isEnabled: Bool = true
    public var separator: TableViewSeparator = .none
    public var separatorColor: UIColor = .separator
    public var margin = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
    public private(set) var isVisible: Bool = false
    public var leadingActions = [TableViewContextualAction]()
    public var trailingActions = [TableViewContextualAction]()

    var select: ((TableViewData) -> Void)?
    var drag: ((TableViewData, IndexPath) -> Void)?

    private(set) var display: ((TableViewData) -> Void)?
    private(set) var hide: ((TableViewData) -> Void)?

    public static func == (lhs: TableViewData, rhs: TableViewData) -> Bool { lhs.isEqual(to: rhs) }
    open func isEqual(to other: TableViewData) -> Bool { isEnabled == other.isEnabled }
    open func hash(into _: inout Hasher) {
        // To override
    }

    public init() {
        // Public init
    }

    @discardableResult
    public func did(select: ((TableViewData) -> Void)?) -> Self {
        self.select = select
        return self
    }
}

public extension TableViewData {
    @discardableResult
    func set(backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }

    @discardableResult
    func set(enabled: Bool) -> Self {
        self.isEnabled = enabled
        return self
    }

    @discardableResult
    func set(selectable: Bool) -> Self {
        self.isSelectable = selectable
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

    @discardableResult
    func add(trailingAction: TableViewContextualAction, onlyIf condition: Bool) -> Self {
        guard condition else { return self }
        self.trailingActions.append(trailingAction)
        return self
    }

    @discardableResult
    func add(leadingAction: TableViewContextualAction, onlyIf condition: Bool) -> Self {
        guard condition else { return self }
        self.leadingActions.append(leadingAction)
        return self
    }

    @discardableResult
    func set(leadingActions: [TableViewContextualAction]) -> Self {
        self.leadingActions = leadingActions
        return self
    }

    @discardableResult
    func set(trailingActions: [TableViewContextualAction]) -> Self {
        self.trailingActions = trailingActions
        return self
    }

    @discardableResult
    func set(accessory: UITableViewCell.AccessoryType) -> Self {
        self.accessory = accessory
        return self
    }

    @discardableResult
    func did(drag: ((TableViewData, IndexPath) -> Void)?) -> Self {
        self.drag = drag
        return self
    }

    @discardableResult
    func will(display: ((TableViewData) -> Void)?) -> Self {
        self.display = { [weak self] data in
            self?.isVisible = true
            display?(data)
        }
        return self
    }

    @discardableResult
    func will(hide: ((TableViewData) -> Void)?) -> Self {
        self.hide = { [weak self] data in
            self?.isVisible = false
            hide?(data)
        }
        return self
    }
}

public extension TableViewData {
    @discardableResult
    func add(to datas: inout [TableViewData]) -> Self {
        datas.append(self)
        return self
    }

    @discardableResult
    func insert(to datas: inout [TableViewData], at index: Int) -> Self {
        datas.insert(self, at: index)
        return self
    }

    @discardableResult
    func remove(to datas: inout [TableViewData]) -> Self {
        datas.removeAll(where: { $0 === self })
        return self
    }
}

public extension Array where Element: TableViewData {
    @discardableResult
    func add(to datas: inout [TableViewData]) -> Self {
        datas.append(contentsOf: self)
        return self
    }
}

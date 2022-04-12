//
//  TableViewCell.swift
//  GlobalUI
//
//

import Foundation
import UIKit

open class TableViewCell: UITableViewCell {
    public let containerView = UIView.useConstraint
    let separatorView = UIView.useConstraint

    var containerLeadingConstraint: NSLayoutConstraint?
    var containerTrailingConstraint: NSLayoutConstraint?
    var containerTopConstraint: NSLayoutConstraint?
    var containerBottomConstraint: NSLayoutConstraint?

    var separatorLeadingConstraint: NSLayoutConstraint?
    var separatorTrailingConstraint: NSLayoutConstraint?

    public var data: TableViewData!

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configure()
        setupLayout()
    }
    public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    open func addSubviews() {
        contentView.add(subviews: containerView)
        addSubview(separatorView)
    }

    open func configure() {
        separatorView.backgroundColor = .separator
    }

    open func setupLayout() {
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])

        containerLeadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        containerTrailingConstraint = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        containerTopConstraint = containerView.topAnchor.constraint(equalTo: contentView.topAnchor)
        containerBottomConstraint = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        containerLeadingConstraint?.isActive = true
        containerTrailingConstraint?.isActive = true
        containerTopConstraint?.isActive = true
        containerBottomConstraint?.isActive = true

        separatorLeadingConstraint = separatorView.leadingAnchor.constraint(equalTo: leadingAnchor)
        separatorTrailingConstraint = separatorView.trailingAnchor.constraint(equalTo: trailingAnchor)

        separatorLeadingConstraint?.isActive = true
        separatorTrailingConstraint?.isActive = true
    }

    open func load(data: TableViewData) {
        self.data = data
        backgroundColor = data.backgroundColor
        contentView.backgroundColor = .clear
        accessoryType = data.isEnabled ? data.accessory : .none
        selectionStyle = data.isSelectable ? .default : .none
        containerLeadingConstraint?.constant = data.margin.left
        containerTrailingConstraint?.constant = -data.margin.right
        containerTopConstraint?.constant = data.margin.top
        containerBottomConstraint?.constant = -data.margin.bottom
        refreshSeparator()
    }

    func refreshSeparator() {
        separatorView.backgroundColor = data.separatorColor
        switch data.separator {
        case .none:
            separatorView.isHidden = true
        case .full:
            separatorView.isHidden = false
            separatorLeadingConstraint?.constant = 0
            separatorTrailingConstraint?.constant = 0
        case let .custom(left, right):
            separatorView.isHidden = false
            separatorLeadingConstraint?.constant = left
            separatorTrailingConstraint?.constant = -right
        }
    }

    public func didSelect() {
        guard let data = data, data.isEnabled else { return }
        data.select?(data)
    }
}

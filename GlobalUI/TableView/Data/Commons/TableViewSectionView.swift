//
//  TableViewSectionView.swift
//  GlobalUI
//
//

import Foundation
import UIKit

open class TableViewSectionView: UIView {
    var section: TableViewSection!

    public let containerView = UIView.useConstraint
    let separatorView = UIView.useConstraint

    var containerLeadingConstraint: NSLayoutConstraint?
    var containerTrailingConstraint: NSLayoutConstraint?
    var containerTopConstraint: NSLayoutConstraint?
    var containerBottomConstraint: NSLayoutConstraint?

    var separatorLeadingConstraint: NSLayoutConstraint?
    var separatorTrailingConstraint: NSLayoutConstraint?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configure()
        setupLayout()
    }
    public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    open func addSubviews() {
        add(subviews: containerView, separatorView)
    }

    open func configure() {
        separatorView.backgroundColor = .separator
    }

    open func setupLayout() {
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])

        containerLeadingConstraint = containerView.leadingAnchor.constraint(equalTo: leadingAnchor)
        containerTrailingConstraint = containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        containerTopConstraint = containerView.topAnchor.constraint(equalTo: topAnchor)
        containerBottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor)

        containerLeadingConstraint?.isActive = true
        containerTrailingConstraint?.isActive = true
        containerTopConstraint?.isActive = true
        containerBottomConstraint?.isActive = true

        separatorLeadingConstraint = separatorView.leadingAnchor.constraint(equalTo: leadingAnchor)
        separatorTrailingConstraint = separatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        separatorLeadingConstraint?.isActive = true
        separatorTrailingConstraint?.isActive = true
    }

    open func load(section: TableViewSection) {
        self.section = section
        backgroundColor = section.backgroundColor
        containerLeadingConstraint?.constant = section.margin.left
        containerTrailingConstraint?.constant = -section.margin.right
        containerTopConstraint?.constant = section.margin.top
        containerBottomConstraint?.constant = -section.margin.bottom
        refreshSeparator()
    }

    func refreshSeparator() {
        separatorView.backgroundColor = section.separatorColor
        switch section.separator {
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
}

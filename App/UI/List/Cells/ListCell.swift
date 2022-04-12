//
//  ListCell.swift
//  App
//
//

import GlobalUI
import UIKit

class ListCell: TableViewCell {

    private var label = UILabel.useConstraint

    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(label)
    }

    override func configure() {
        super.configure()
        label.textColor = .white
    }

    override func setupLayout() {
        super.setupLayout()
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }

    override func load(data: TableViewData) {
        super.load(data: data)
        guard let data = data as? ListCellData else { return }
        self.label.text = data.title
    }
}

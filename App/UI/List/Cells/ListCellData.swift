//
//  ListTableData.swift
//  App
//
//

import GlobalUI

class ListCellData: TableViewData {
    override var cellType: TableViewCell.Type? { ListCell.self }

    private var forecast: ForecastItem

    var title: String {
        ""
    }

    init(forecast: ForecastItem) {
        self.forecast = forecast
        super.init()
    }

    override func hash(into hasher: inout Hasher) {
        // TODO
        // hasher.combine("\(forecast.day)")
    }

    override func isEqual(to other: TableViewData) -> Bool {
        guard let other = other as? ListCellData else { return false }
        // TODO
        // return self.forecast.day == other.forecast.day
        return false
    }
}

//
//  ListViewModel.swift
//  App
//
//

import Global
import GlobalUI
import Combine

class ListViewModel {
    @Inject var service: ForecastService
    private var bag = Set<AnyCancellable>()

    var datas = CurrentValueSubject<[TableViewSection], Never>([])

    var showDetail: ((ForecastItem) -> Void)?

    var title: String = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as! String

    init() {
        service.items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.createSection($0) }
            .store(in: &bag)
    }

    private func createSection(_ items: ForecastItems) {
        let datas: [TableViewData] = items.map {
            ListCellData(forecast: $0)
                .set(trailingActions: [self.trailingAction(item: $0)])
                .set(separator: .full)
                .set(separatorColor: .lightGray)
                .did(select: nil)

        }
        self.datas.send([TableViewSection(identifier: "section",
                                          datas: datas)])
    }

    private func trailingAction(item: ForecastItem) -> TableViewContextualAction {
        return TableViewContextualAction(title: "Delete", style: .destructive, backgroundColor: .red, action: nil)
    }
}

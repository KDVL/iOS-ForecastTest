//
//  TableView.swift
//  GlobalUI
//
//

import UIKit
import Global
import Combine

public class TableView: UITableView {
    public weak var tableViewDelegate: TableViewDelegate?

    private var bag = Set<AnyCancellable>()
    private var diffableDataSource: TableViewDataSource!
    public var swipeActionIsOpen: Bool = false
    public var animation: UITableView.RowAnimation = .fade
    var firstLoading: Bool = true
    public weak var parentViewController: UIViewController?

    var sections: [TableViewSection] = [] {
        didSet { reload() }
    }

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initialize()
    }
    public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func initialize() {
        separatorStyle = .none
        backgroundColor = .clear
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }

        diffableDataSource = TableViewDataSource(tableView: self) { tableView, indexPath, data in
            let cell = tableView.dequeueReusableCell(withIdentifier: data.data.cellIdentifier, for: indexPath)
            guard let tableViewCell = cell as? TableViewCell else { return UITableViewCell() }
            tableViewCell.load(data: data.data)
            tableViewCell.isEditing = tableView.isEditing
            return cell
        }
        diffableDataSource.defaultRowAnimation = .fade
    }

    public func configure(sections: CurrentValueSubject<[TableViewSection], Never>) {
        bag = Set<AnyCancellable>()
        sections
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self?.sections = $0 })
            .store(in: &bag)
    }

    func reload() {
        registerCells()
        delegate = self
        dragInteractionEnabled = true
        dragDelegate = self
        dropDelegate = self
        apply()
    }

    func registerCells() {
        sections.forEach {
            $0.datas.forEach {
                register($0.cellType, forCellReuseIdentifier: $0.cellIdentifier)
            }
        }
    }

    func apply(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<TableViewSectionComponent, TableViewDataComponent>()
        let sectionComponents = sections.map { TableViewSectionComponent(section: $0) }
        snapshot.appendSections(sectionComponents)
        sectionComponents.forEach {
            snapshot.appendItems($0.section.datas.map { TableViewDataComponent(data: $0) }, toSection: $0)
        }
        self.diffableDataSource.apply(snapshot, animatingDifferences: !firstLoading && animatingDifferences)
        if sections.contains(where: { !$0.datas.isEmpty }) {
            firstLoading = false
        }
    }
}

extension TableView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableViewDelegate?.tableViewDidDeselect(tableView: self, indexPath: indexPath)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isEditing || (isEditing && !allowsMultipleSelectionDuringEditing) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        tableViewDelegate?.tableViewDidSelect(tableView: self, indexPath: indexPath)
        (tableView.cellForRow(at: indexPath) as? TableViewCell)?.didSelect()
    }

    public func tableView(_ tableView: UITableView,
                          leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let data = sections[safe: indexPath.section]?.datas[safe: indexPath.row],
              data.isEnabled else { return nil }
        let actions = contextualActions(from: data.leadingActions, data: data)
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    public func tableView(_ tableView: UITableView,
                          trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let data = sections[safe: indexPath.section]?.datas[safe: indexPath.row],
              data.isEnabled else { return nil }
        let actions = contextualActions(from: data.trailingActions, data: data)
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    func contextualActions(from actions: [TableViewContextualAction], data: TableViewData) -> [UIContextualAction] {
        actions.map { actionData in
            let action = UIContextualAction(style: actionData.style, title: actionData.title) { _, _, handler in
                handler(true)
                actionData.action?(data)
            }
            action.backgroundColor = actionData.backgroundColor
            action.image = actionData.image
            return action
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let tableViewSection = diffableDataSource.snapshot().sectionIdentifiers[safe: section],
              let sectionType = tableViewSection.section.sectionType else { return nil }
        let view = sectionType.init()
        view.load(section: tableViewSection.section)
        return view
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let tableViewSection = diffableDataSource.snapshot().sectionIdentifiers[safe: section],
              tableViewSection.section.sectionType != nil else { return 0 }
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        swipeActionIsOpen = true
        tableViewDelegate?.tableViewDidSwipeAction(tableView: self)
    }

    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        swipeActionIsOpen = false
        tableViewDelegate?.tableViewDidSwipeAction(tableView: self)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableViewDelegate?.scrollViewDidScroll(self)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableViewDelegate?.scrollViewWillBeginDragging(self)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableViewDelegate?.scrollViewDidEndDragging(self, willDecelerate: decelerate)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let data = sections[safe: indexPath.section]?.datas[safe: indexPath.row] else { return }
        data.display?(data)
    }
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell,
                          forRowAt indexPath: IndexPath) {
        guard let data = sections[safe: indexPath.section]?.datas[safe: indexPath.row] else { return }
        data.hide?(data)
    }
}

class TableViewDataSource: UITableViewDiffableDataSource<TableViewSectionComponent, TableViewDataComponent> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let section = snapshot().sectionIdentifiers[safe: indexPath.section],
              let component = snapshot().itemIdentifiers(inSection: section)[safe: indexPath.row],
              component.data.isEnabled, !component.data.trailingActions.isEmpty else { return false }
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let section = snapshot().sectionIdentifiers[safe: sourceIndexPath.section],
              let element = itemIdentifier(for: sourceIndexPath), sourceIndexPath != destinationIndexPath else { return }
        var snap = snapshot()
        snap.deleteItems([element])
        
        if let toElement = itemIdentifier(for: destinationIndexPath) {
            let isAfter = destinationIndexPath.row > sourceIndexPath.row
            
            if isAfter {
                snap.insertItems([element], afterItem: toElement)
            } else {
                snap.insertItems([element], beforeItem: toElement)
            }
        } else {
            snap.appendItems([element], toSection: section)
        }
        
        element.data.drag?(element.data, destinationIndexPath)
        apply(snap, animatingDifferences: false)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let element = itemIdentifier(for: indexPath), element.data.isEnabled,
              element.data.drag != nil else { return false }
        return true
    }
}

struct TableViewDataComponent: Hashable {
    var data: TableViewData

    static func == (lhs: TableViewDataComponent, rhs: TableViewDataComponent) -> Bool {
        lhs.data == rhs.data
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: type(of: data)))
        data.hash(into: &hasher)
    }
}

struct TableViewSectionComponent: Hashable {
    var section: TableViewSection

    static func == (lhs: TableViewSectionComponent, rhs: TableViewSectionComponent) -> Bool {
        lhs.section == rhs.section
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: type(of: section)))
        section.hash(into: &hasher)
    }
}

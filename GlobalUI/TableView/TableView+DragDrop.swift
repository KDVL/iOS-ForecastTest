//
//  TableView+Drag&Drop.swift
//  GlobalUI
//
//

import UIKit
import Global

extension TableView: UITableViewDragDelegate {
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession,
                          at indexPath: IndexPath) -> [UIDragItem] {
        guard let data = sections[safe: indexPath.section]?.datas[safe: indexPath.row],
              data.isEnabled, data.drag != nil else { return [] }
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = data
        return [dragItem]
    }
    public func tableView(_ tableView: UITableView,
                          dragSessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool { true }
    public func tableView(_ tableView: UITableView,
                          dragSessionAllowsMoveOperation session: UIDragSession) -> Bool { true }
    public func tableView(_ tableView: UITableView,
                          dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let result = UIDragPreviewParameters()
        if let cell = tableView.cellForRow(at: indexPath) {
            let path = UIBezierPath(rect: cell.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
            result.backgroundColor = .clear
            result.visiblePath = path
        }
        return result
    }
}

// MARK: - Drop management
extension TableView: UITableViewDropDelegate {
    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        // To be complete if needed
    }

    public func tableView(_ tableView: UITableView,
                          dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let result = UIDragPreviewParameters()
        if let cell = tableView.cellForRow(at: indexPath) {
            let path = UIBezierPath(rect: cell.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
            result.backgroundColor = .clear
            result.visiblePath = path
        }
        return result
    }

    public func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool { true }

    public func tableView(_ tableView: UITableView,
                          dropSessionDidUpdate session: UIDropSession,
                          withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        guard let destinationIndexPath = destinationIndexPath,
              let data = sections[safe: destinationIndexPath.section]?.datas[safe: destinationIndexPath.row],
              data.isEnabled, data.drag != nil else { return .init(operation: .forbidden) }
        return .init(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

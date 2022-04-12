//
//  TableViewDelegate.swift
//  GlobalUI
//
//

import Foundation

public protocol TableViewDelegate: AnyObject {
    func tableViewDidSwipeAction(tableView: TableView)
    func tableViewDidSelect(tableView: TableView, indexPath: IndexPath)
    func tableViewDidDeselect(tableView: TableView, indexPath: IndexPath)
    func scrollViewDidScroll(_ scrollView: TableView)
    func scrollViewWillBeginDragging(_ tableView: TableView)
    func scrollViewDidEndDragging(_ tableView: TableView, willDecelerate decelerate: Bool)
}

public extension TableViewDelegate {
    func tableViewDidSwipeAction(tableView _: TableView) {
        // Optional function
    }
    func tableViewDidSelect(tableView _: TableView, indexPath _: IndexPath) {
        // Optional function
    }
    func tableViewDidDeselect(tableView _: TableView, indexPath _: IndexPath) {
        // Optional function
    }
    func scrollViewDidScroll(_: TableView) {
        // Optional function
    }
    func scrollViewWillBeginDragging(_: TableView) {
        // Optional function
    }
    func scrollViewDidEndDragging(_: TableView, willDecelerate _: Bool) {
        // Optional function
    }
}

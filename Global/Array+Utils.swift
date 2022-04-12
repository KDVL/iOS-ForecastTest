//
//  Array+Utils.swift
//  Global
//
//

import Foundation

public extension Array {
    subscript(safe index: Index) -> Element? {
        0 <= index && index < count ? self[index] : nil
    }
}

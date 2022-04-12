//
//  Module.swift
//  Global
//
//

import Foundation

public protocol Module {
    func registerServices()
}

public extension Module {
    func registerServices() {
        // No registered services
    }
}

//
//  ModuleManager.swift
//  Global
//
//

import Foundation

public class ModuleManager {
    public var modules = [Module]()

    public static let shared = ModuleManager()
    private init() {
//        Singleton
    }

    public func register(module: Module) {
        modules.append(module)
    }
}

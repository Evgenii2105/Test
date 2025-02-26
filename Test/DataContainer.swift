//
//  DataContainer.swift
//  Test
//
//  Created by Евгений Фомичев on 19.02.2025.
//

import Foundation

protocol DataContainer {
    
    var personalArray: [DataContainerImpl.Section] { get }
    var children: [Child] { get }
}

struct Child {
    
    static func makeEmptyChild() -> Self {
        Child(name: "", age: 0)
    }
    
    var name: String
    var age: Int
}

class DataContainerImpl: DataContainer {
    
    var personalArray: [Section] = [.personalData, .addChildren]
    
    enum Section: Int {
        case personalData
        case addChildren
        case children
    }
    
    var children: [Child] = []
    
    func index(for section: Int) -> Section {
       
        return Section(rawValue: section) ?? .children
    }
    
    func addChild(_ child: Child) {
        children.append(child)
    }
    
    func remove(_ index: Int) {
        children.remove(at: index)
    }
}

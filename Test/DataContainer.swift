//
//  DataContainer.swift
//  Test
//
//  Created by Евгений Фомичев on 19.02.2025.
//

import Foundation

protocol DataContainer: AnyObject {
    
    var personalArray: [DataContainerImpl.Section] { get }
    var children: [Child] { get }
    
    func addChild(_ child: Child)
    func removeChild(at index: Int)
    
    func clearChildren()
    func index(for section: Int) -> DataContainerImpl.Section
    
    func updateChildName(at index: Int, name: String)
    func updateChildAge(at index: Int, age: Int)
    
    func updatePersonalName(name: String)
    func updatePersonalAge(age: Int)
    func clearPersonalData()
    var personalData: PersonalData { get }
}

struct Child {
    
    static func makeEmptyChild() -> Self {
        Child(name: "", age: 0)
    }
    
    var name: String
    var age: Int
}

struct PersonalData {
    
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
    var personalData: PersonalData = PersonalData(name: "", age: 0)
    
    func index(for section: Int) -> Section {
        
        if section < personalArray.count {
            return personalArray[section]
        } else {
            return .children
        }
    }
    
    func addChild(_ child: Child) {
        children.append(child)
    }
    
    func removeChild(at index: Int) {
        guard index >= 0, index < children.count else {
            return
        }
        children.remove(at: index)
    }
    
    func getChildren() -> [Child] {
        return children
    }
    
    func clearChildren() {
        children.removeAll()
    }
    
    func clearPersonalData() {
        personalData.age = 0
        personalData.name = ""
    }
    
    func updateChildName(at index: Int, name: String) {
        
        guard index < children.count else { return }
        children[index].name = name
    }
    
    func updateChildAge(at index: Int, age: Int) {
        guard index < children.count else { return }
        children[index].age = age
    }
    
    func updatePersonalName(name: String) {
        personalData.name = name
    }
    
    func updatePersonalAge(age: Int) {
        personalData.age = age
    }
}

//
//  DataContainer.swift
//  Test
//
//  Created by Евгений Фомичев on 19.02.2025.
//

import Foundation

protocol DataContainer: AnyObject {
    
    var personalArray: [DataContainerImpl.Section] { get }
    var children: [Personal] { get }
    var personalData: Personal { get }
    var isDataEmpty: Bool { get }
    
    func addChild(_ child: Personal)
    func removeChild(at index: Int)
    
    func clearChildren()
    func index(for section: Int) -> DataContainerImpl.Section
    
    func updateChildName(at index: Int, name: String)
    func updateChildAge(at index: Int, age: Int)
    
    func updatePersonalName(name: String)
    func updatePersonalAge(age: Int)
    func clearPersonalData()
}

struct Personal {
    
    var name: String
    var age: Int
}

class DataContainerImpl: DataContainer {
    
    static let limitChildren = 5
    
    var personalArray: [Section] = [.personalData, .addChildren]
    
    enum Section: Int {
        case personalData
        case addChildren
        case children
    }
    
    var children: [Personal] = []
    var personalData: Personal = Personal(name: "", age: 0)
    
    func index(for section: Int) -> Section {
        
        if section < personalArray.count {
            return personalArray[section]
        } else {
            return .children
        }
    }
    
    func addChild(_ child: Personal) {
        children.append(child)
    }
    
    func removeChild(at index: Int) {
        guard 0..<children.count ~= index else { return }
        children.remove(at: index)
    }
    
    func clearChildren() {
        children.removeAll()
    }
    
    func clearPersonalData() {
        personalData.name = ""
        personalData.age = 0
        personalData.name = ""
        personalData.age = 0
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
    
    var isDataEmpty: Bool {
        return personalData.name.isEmpty && personalData.age == 0 && children.isEmpty
    }
}

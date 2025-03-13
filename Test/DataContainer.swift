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
    
    func addChild(_ child: Personal)
    func removeChild(at index: Int)
    
    func clearChildren()
    func index(for section: Int) -> DataContainerImpl.Section
    
    func updateChildName(at index: Int, name: String)
    func updateChildAge(at index: Int, age: Int)
    
    func updatePersonalName(name: String)
    func updatePersonalAge(age: Int)
    func clearPersonalData()
    var personalData: Personal { get }
    var isDataEmpty: Bool { get }
}

struct Personal {
    
    var namePeronal: String
    var agePersonal: Int
    var nameChild: String
    var ageChild: Int
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
    var personalData: Personal = Personal(namePeronal: "", agePersonal: 0, nameChild: "", ageChild: 0)
    
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
        guard index >= 0, index < children.count else { return }
        children.remove(at: index)
    }
    
    func clearChildren() {
        children.removeAll()
    }
    
    func clearPersonalData() {
        personalData.namePeronal = ""
        personalData.agePersonal = 0
        personalData.nameChild = ""
        personalData.ageChild = 0
    }
    
    func updateChildName(at index: Int, name: String) {
        
        guard index < children.count else { return }
        children[index].nameChild = name
    }
    
    func updateChildAge(at index: Int, age: Int) {
        guard index < children.count else { return }
        children[index].ageChild = age
    }
    
    func updatePersonalName(name: String) {
        personalData.namePeronal = name
    }
    
    func updatePersonalAge(age: Int) {
        personalData.agePersonal = age
    }
    
    var isDataEmpty: Bool {
        return personalData.namePeronal.isEmpty && personalData.agePersonal == 0 && children.isEmpty
    }
}

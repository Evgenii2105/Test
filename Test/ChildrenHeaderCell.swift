//
//  ChildrenHeaderCell.swift
//  Test
//
//  Created by Евгений Фомичев on 21.02.2025.
//

import UIKit

protocol HeaderDelegate: AnyObject {
    func tapAddChildren(name: String, age: Int)
}

class ChildrenHeaderCell: UITableViewCell {
    
    static let cellIdentifier = "ChildrenHeaderCell"
    
    weak var delegate: HeaderDelegate?
    
    private let childrenLabel: UILabel = {
        let childrenLabel = UILabel()
        childrenLabel.text = "Детей(макс.5)"
        childrenLabel.textColor = .black
        childrenLabel.font = .systemFont(ofSize: 18)
        childrenLabel.translatesAutoresizingMaskIntoConstraints = false
        return childrenLabel
    }()
    
    private let addChildren: UIButton = {
        let addChildren = UIButton()
        addChildren.setTitle("+ Добавить ребенка", for: .normal)
        addChildren.translatesAutoresizingMaskIntoConstraints = false
        addChildren.backgroundColor = .systemBackground
        addChildren.layer.borderWidth = 2
        addChildren.layer.borderColor = UIColor.systemBlue.cgColor
        addChildren.setTitleColor(.systemBlue, for: .normal)
        addChildren.layer.cornerRadius = 15
        return addChildren
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(childrenLabel)
        contentView.addSubview(addChildren)
        
        setupConstraints()
        
        addChildren.addTarget(self, action: #selector(addChildrenButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func addChildrenButton(_ sender: UIButton) {
        delegate?.tapAddChildren(name: "", age: 0)
        print("кнопка нажата")
    }
    
    func setAddButtonVisibility(isHidden: Bool ) {
        addChildren.isHidden = isHidden
        addChildren.isEnabled = !isHidden
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            addChildren.topAnchor.constraint(equalTo: contentView.topAnchor),
            addChildren.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            addChildren.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            childrenLabel.centerYAnchor.constraint(equalTo: addChildren.centerYAnchor),
            childrenLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        ])
    }
}

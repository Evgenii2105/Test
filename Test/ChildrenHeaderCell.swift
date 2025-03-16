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
        childrenLabel.font = .systemFont(ofSize: 22)
        childrenLabel.translatesAutoresizingMaskIntoConstraints = false
        return childrenLabel
    }()
    
    private let addChildrenButton: UIButton = {
        let addChildrenButton = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.title = "+ Добавить ребенка"
        configuration.background.backgroundColor = .systemBackground
        configuration.background.strokeWidth = 2
        configuration.baseForegroundColor = .systemBlue
        configuration.background.strokeColor = .systemBlue
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        configuration.background.cornerRadius = 15
        
        addChildrenButton.configuration = configuration
        addChildrenButton.translatesAutoresizingMaskIntoConstraints = false
        return addChildrenButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(childrenLabel)
        contentView.addSubview(addChildrenButton)
        setupConstraints()
        
        addChildrenButton.addTarget(self, action: #selector(addChildren), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func addChildren(_ sender: UIButton) {
        delegate?.tapAddChildren(name: "", age: 0)
    }
    
    func configure(isAddButtonHidden: Bool) {
        addChildrenButton.isHidden = isAddButtonHidden
        addChildrenButton.isEnabled = !isAddButtonHidden
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            addChildrenButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            addChildrenButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            addChildrenButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            childrenLabel.centerYAnchor.constraint(equalTo: addChildrenButton.centerYAnchor),
            childrenLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        ])
    }
}

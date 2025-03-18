//
//  ChildrenAddCell.swift
//  Test
//
//  Created by Евгений Фомичев on 21.02.2025.
//

import UIKit

protocol HeaderDelegate: AnyObject {
    func tapAddChildren(name: String, age: Int)
}

class ChildrenAddCell: UITableViewCell {
    
    static let cellIdentifier = "ChildrenHeaderCell"
    
    weak var delegate: HeaderDelegate?
    
    static let maxChildren = 5
    
    private let childrenLabel: UILabel = {
        let childrenLabel = UILabel()
        childrenLabel.text = "Детей(макс. \(ChildrenAddCell.maxChildren)"
        childrenLabel.textColor = .black
        childrenLabel.font = .systemFont(ofSize: 22)
        childrenLabel.translatesAutoresizingMaskIntoConstraints = false
        return childrenLabel
    }()
    
    private let addChildrenButton: UIButton = {
        let addChildrenButton = UIButton()
        var configuration = UIButton.Configuration.plain()
        let plusImage = UIImage(systemName: "plus")
        configuration.image = plusImage
        configuration.title = "Добавить ребенка"
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        configuration.background.backgroundColor = .systemBackground
        configuration.background.strokeWidth = 2
        configuration.baseForegroundColor = .systemBlue
        configuration.background.strokeColor = .systemBlue
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                              leading: 16,
                                                              bottom: 8,
                                                              trailing: 16)
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
        setupAction()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAction() {
        
        let addAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.tapAddChildren(name: "", age: 0)
        }
        addChildrenButton.addAction(addAction, for: .touchUpInside)
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

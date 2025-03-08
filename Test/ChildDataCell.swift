//
//  ChildDataCell.swift
//  Test
//
//  Created by Евгений Фомичев on 21.02.2025.
//

import UIKit

protocol ChildDataCellDelegate: AnyObject {
    
    func didTapDeleteButton(cell: ChildDataCell)
    func didUpdateChildName(cell: ChildDataCell, name: String)
    func didUpdateChildAge(cell: ChildDataCell, age: Int)
}

class ChildDataCell: UITableViewCell {
    
    static let cellIdentifier = "DataChildCell"
    
    weak var delegate: ChildDataCellDelegate?
    
    private let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        return separatorView
    }()
    
    private let nameContainerChild: UIView = {
        let nameContainerChild = UIView()
        nameContainerChild.backgroundColor = .white
        nameContainerChild.layer.borderColor = UIColor.lightGray.cgColor
        nameContainerChild.layer.borderWidth = 1.0
        nameContainerChild.layer.cornerRadius = 8.0
        nameContainerChild.translatesAutoresizingMaskIntoConstraints = false
        return nameContainerChild
    }()
    
    private let ageContainerChild: UIView = {
        let ageContainerChild = UIView()
        ageContainerChild.backgroundColor = .white
        ageContainerChild.layer.borderColor = UIColor.lightGray.cgColor
        ageContainerChild.layer.borderWidth = 1.0
        ageContainerChild.layer.cornerRadius = 8.0
        ageContainerChild.translatesAutoresizingMaskIntoConstraints = false
        return ageContainerChild
    }()
    
    private let textChildrenName: UITextField = {
        let textChildrenName = UITextField()
        textChildrenName.placeholder = "Введите имя"
        textChildrenName.translatesAutoresizingMaskIntoConstraints = false
        return textChildrenName
    }()
    
    private let titleLabelNameChildren: UILabel = {
        let titleLabelNameChildren = UILabel()
        titleLabelNameChildren.numberOfLines = 0
        titleLabelNameChildren.text = "Имя"
        titleLabelNameChildren.font = .systemFont(ofSize: 24)
        titleLabelNameChildren.font = .preferredFont(forTextStyle: .footnote)
        titleLabelNameChildren.adjustsFontSizeToFitWidth = false
        titleLabelNameChildren.lineBreakMode = .byWordWrapping
        titleLabelNameChildren.textColor = .gray
        titleLabelNameChildren.translatesAutoresizingMaskIntoConstraints = false
        return titleLabelNameChildren
    }()
    
    private let titleLabelAgeChildren: UILabel = {
        let titleLabelAgeChildren = UILabel()
        titleLabelAgeChildren.text = "Возраст"
        titleLabelAgeChildren.translatesAutoresizingMaskIntoConstraints = false
        titleLabelAgeChildren.font = .systemFont(ofSize: 24)
        titleLabelAgeChildren.textColor = .gray
        titleLabelAgeChildren.font = .preferredFont(forTextStyle: .footnote)
        return titleLabelAgeChildren
    }()
    
    private let textAgeChildren: UITextField = {
        let textAgeChildren = UITextField()
        textAgeChildren.placeholder = "Введите возраст"
        textAgeChildren.keyboardType = .numberPad
        textAgeChildren.translatesAutoresizingMaskIntoConstraints = false
        return textAgeChildren
    }()
    
    private let deleteChildren: UIButton = {
        let deleteChildren = UIButton()
        var configure = UIButton.Configuration.plain()
        deleteChildren.setTitle("Удалить", for: .normal)
        deleteChildren.setTitleColor(.systemBlue, for: .normal)
        deleteChildren.layer.cornerRadius = 15
        deleteChildren.backgroundColor = .systemBackground
        deleteChildren.translatesAutoresizingMaskIntoConstraints = false
        configure.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        deleteChildren.configuration = configure
        return deleteChildren
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(nameContainerChild)
        contentView.addSubview(ageContainerChild)
        nameContainerChild.addSubview(titleLabelNameChildren)
        nameContainerChild.addSubview(textChildrenName)
        ageContainerChild.addSubview(titleLabelAgeChildren)
        ageContainerChild.addSubview(textAgeChildren)
        contentView.addSubview(deleteChildren)
        contentView.addSubview(separatorView)
        
        setupConstraints()
        configureTableText()
        
        deleteChildren.addTarget(self, action: #selector(deleteChildrenButton), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func deleteChildrenButton(_ sender: UIButton) {
        delegate?.didTapDeleteButton(cell: self)
    }
    
    private func configureTableText() {
        textChildrenName.delegate = self
        textAgeChildren.delegate = self
        
    }
    
    func configure(with data: Child, shouldShowSeparator: Bool) {
        textChildrenName.text = data.name.isEmpty ? "" : data.name
        textAgeChildren.text = data.age == 0 ? "" : "\(data.age)"
        separatorView.isHidden = !shouldShowSeparator
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            nameContainerChild.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameContainerChild.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameContainerChild.trailingAnchor.constraint(equalTo: deleteChildren.leadingAnchor, constant: -30),
            nameContainerChild.bottomAnchor.constraint(equalTo: ageContainerChild.topAnchor, constant: -8),
            
            titleLabelNameChildren.topAnchor.constraint(equalTo: nameContainerChild.topAnchor, constant: 8),
            titleLabelNameChildren.leadingAnchor.constraint(equalTo: nameContainerChild.leadingAnchor, constant: 8),
            titleLabelNameChildren.trailingAnchor.constraint(equalTo: nameContainerChild.trailingAnchor, constant: -8),
            
            textChildrenName.topAnchor.constraint(equalTo: titleLabelNameChildren.bottomAnchor, constant: 8),
            textChildrenName.leadingAnchor.constraint(equalTo: nameContainerChild.leadingAnchor, constant: 8),
            textChildrenName.trailingAnchor.constraint(equalTo: nameContainerChild.trailingAnchor, constant: -8),
            textChildrenName.bottomAnchor.constraint(equalTo: nameContainerChild.bottomAnchor, constant: -8),
            
            ageContainerChild.topAnchor.constraint(equalTo: nameContainerChild.bottomAnchor, constant: 16),
            ageContainerChild.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ageContainerChild.trailingAnchor.constraint(equalTo: deleteChildren.leadingAnchor, constant: -30),
            ageContainerChild.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabelAgeChildren.topAnchor.constraint(equalTo: ageContainerChild.topAnchor, constant: 8),
            titleLabelAgeChildren.leadingAnchor.constraint(equalTo: ageContainerChild.leadingAnchor, constant: 8),
            titleLabelAgeChildren.trailingAnchor.constraint(equalTo: ageContainerChild.trailingAnchor, constant: -8),
            
            textAgeChildren.topAnchor.constraint(equalTo: titleLabelAgeChildren.bottomAnchor, constant: 8),
            textAgeChildren.leadingAnchor.constraint(equalTo: ageContainerChild.leadingAnchor, constant: 8),
            textAgeChildren.trailingAnchor.constraint(equalTo: ageContainerChild.trailingAnchor, constant: -8),
            textAgeChildren.bottomAnchor.constraint(equalTo: ageContainerChild.bottomAnchor, constant: -8),
            
            deleteChildren.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -55),
            deleteChildren.centerYAnchor.constraint(equalTo: nameContainerChild.centerYAnchor),
            deleteChildren.widthAnchor.constraint(equalToConstant: 100),
            deleteChildren.heightAnchor.constraint(equalToConstant: 40),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }
}

extension ChildDataCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 25
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == textChildrenName {
            let name = textChildrenName.text ?? ""
            delegate?.didUpdateChildName(cell: self, name: name)
        } else if textField == textAgeChildren {
            let age = Int(textAgeChildren.text ?? "") ?? 0
            delegate?.didUpdateChildAge(cell: self, age: age)
        }
    }
}

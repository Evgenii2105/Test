//
//  ChildDataCell.swift
//  Test
//
//  Created by Евгений Фомичев on 21.02.2025.
//

import UIKit

protocol ChildDataCellDelegate: AnyObject {
    
    func didTapDeleteButton(cell: ChildDataCell)
    func didUpdateChildData(cell: ChildDataCell, name: String, age: Int)
}

class ChildDataCell: UITableViewCell {
    
    static let cellIdentifier = "DataChildCell"
    
    weak var delegate: ChildDataCellDelegate?
    
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
        titleLabelNameChildren.translatesAutoresizingMaskIntoConstraints = false
        return titleLabelNameChildren
    }()
    
    private let titleLabelAgeChildren: UILabel = {
        let titleLabelAgeChildren = UILabel()
        titleLabelAgeChildren.text = "Возраст"
        titleLabelAgeChildren.translatesAutoresizingMaskIntoConstraints = false
        titleLabelAgeChildren.font = .systemFont(ofSize: 24)
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
        deleteChildren.setTitle("Удалить", for: .normal)
        deleteChildren.setTitleColor(.systemBlue, for: .normal)
        deleteChildren.layer.cornerRadius = 15
        deleteChildren.backgroundColor = .systemBackground
        deleteChildren.layer.borderWidth = 2
        deleteChildren.layer.borderColor = UIColor.systemBlue.cgColor
        deleteChildren.translatesAutoresizingMaskIntoConstraints = false
        return deleteChildren
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabelNameChildren)
        contentView.addSubview(textChildrenName)
        contentView.addSubview(titleLabelAgeChildren)
        contentView.addSubview(textAgeChildren)
        contentView.addSubview(deleteChildren)
        
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
        print("кнопка нажата")
        delegate?.didTapDeleteButton(cell: self)
    }
    
    private func configureTableText() {
        textChildrenName.delegate = self
        textAgeChildren.delegate = self
        
        textChildrenName.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textAgeChildren.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    func configure(with data: Child) {
        textChildrenName.text = data.name
        textAgeChildren.text = "\(data.age)"
    }
    
    func clearFields() {
        textChildrenName.text = ""
        textAgeChildren.text = ""
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabelNameChildren.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabelNameChildren.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabelNameChildren.trailingAnchor.constraint(equalTo: deleteChildren.leadingAnchor, constant: -16),
            
            textChildrenName.topAnchor.constraint(equalTo: titleLabelNameChildren.bottomAnchor, constant: 8),
            textChildrenName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            textChildrenName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleLabelAgeChildren.topAnchor.constraint(equalTo: textChildrenName.bottomAnchor, constant: 8),
            titleLabelAgeChildren.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabelAgeChildren.trailingAnchor.constraint(lessThanOrEqualTo: deleteChildren.leadingAnchor, constant: -8),
            
            textAgeChildren.topAnchor.constraint(equalTo: titleLabelAgeChildren.bottomAnchor, constant: 8),
            textAgeChildren.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            textAgeChildren.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textAgeChildren.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            deleteChildren.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            deleteChildren.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            deleteChildren.centerYAnchor.constraint(equalTo: titleLabelNameChildren.centerYAnchor)
        ])
    }
}

extension ChildDataCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 30
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        let name = textChildrenName.text ?? ""
        let age = Int(textAgeChildren.text ?? "") ?? 0
        delegate?.didUpdateChildData(cell: self, name: name, age: age)
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
}


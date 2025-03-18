//
//  PersonalDataCell.swift
//  Test
//
//  Created by Евгений Фомичев on 19.02.2025.
//

import UIKit

protocol CustomTableDelegate: AnyObject {
    
    func didUpdatePesonalName(cell: PersonalDataCell, name: String)
    func didUpdatePesonalAge(cell: PersonalDataCell, age: Int)
}

class PersonalDataCell: UITableViewCell {
    
    static let cellIdentifier = "DataItemCell"
    
    static let maxLength = 30
    
    weak var delegate: CustomTableDelegate?
    
    private let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.placeholder = "Введите имя"
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()
    
    private let nameDataContainer: UIView = {
        let nameDataContainer = UIView()
        nameDataContainer.backgroundColor = .white
        nameDataContainer.layer.borderColor = UIColor.lightGray.cgColor
        nameDataContainer.layer.borderWidth = 1.0
        nameDataContainer.layer.cornerRadius = 8.0
        nameDataContainer.translatesAutoresizingMaskIntoConstraints = false
        return nameDataContainer
    }()
    
    private let ageDataContainer: UIView = {
        let ageDataContainer = UIView()
        ageDataContainer.backgroundColor = .white
        ageDataContainer.layer.borderColor = UIColor.lightGray.cgColor
        ageDataContainer.layer.borderWidth = 1.0
        ageDataContainer.layer.cornerRadius = 8.0
        ageDataContainer.translatesAutoresizingMaskIntoConstraints = false
        return ageDataContainer
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.text = "Имя"
        nameLabel.font = .preferredFont(forTextStyle: .footnote)
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.textColor = .gray
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private let ageLabel: UILabel = {
        let ageLabel = UILabel()
        ageLabel.text = "Возраст"
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.font = .systemFont(ofSize: 24)
        ageLabel.textColor = .gray
        ageLabel.font = .preferredFont(forTextStyle: .footnote)
        return ageLabel
    }()
    
    private let ageTextField: UITextField = {
        let ageTextField = UITextField()
        ageTextField.placeholder = "Введите возраст"
        ageTextField.keyboardType = .numberPad
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        return ageTextField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
        configure()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(nameDataContainer)
        contentView.addSubview(ageDataContainer)
        nameDataContainer.addSubview(nameLabel)
        nameDataContainer.addSubview(nameTextField)
        ageDataContainer.addSubview(ageLabel)
        ageDataContainer.addSubview(ageTextField)
    }
    
    func configure(with data: Person) {
        nameTextField.text = data.name
        ageTextField.text = nil
    }
    
    private func configure() {
        nameTextField.delegate = self
        ageTextField.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            nameDataContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameDataContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameDataContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameDataContainer.bottomAnchor.constraint(equalTo: ageDataContainer.topAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: nameDataContainer.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: nameDataContainer.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: nameDataContainer.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -8),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: nameDataContainer.leadingAnchor, constant: 8),
            nameTextField.trailingAnchor.constraint(equalTo: nameDataContainer.trailingAnchor, constant: -8),
            nameTextField.bottomAnchor.constraint(equalTo: nameDataContainer.bottomAnchor, constant: -4),
            
            ageDataContainer.topAnchor.constraint(equalTo: nameDataContainer.bottomAnchor, constant: 8),
            ageDataContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ageDataContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ageDataContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            ageLabel.topAnchor.constraint(equalTo: ageDataContainer.topAnchor, constant: 8),
            ageLabel.leadingAnchor.constraint(equalTo: ageDataContainer.leadingAnchor, constant: 8),
            ageLabel.trailingAnchor.constraint(equalTo: ageDataContainer.trailingAnchor, constant: -8),
            ageLabel.bottomAnchor.constraint(equalTo: ageTextField.topAnchor, constant: -8),
            
            ageTextField.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 8),
            ageTextField.leadingAnchor.constraint(equalTo: ageDataContainer.leadingAnchor, constant: 8),
            ageTextField.trailingAnchor.constraint(equalTo: ageDataContainer.trailingAnchor, constant: -16),
            ageTextField.bottomAnchor.constraint(equalTo: ageDataContainer.bottomAnchor, constant: -8)
        ])
    }
}

extension PersonalDataCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        let maxLength = PersonalDataCell.maxLength
        
        if newText.count > maxLength {
            let truncatedText = String(newText.prefix(maxLength))
            textField.text = truncatedText
            return false
        }
        return true
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
        if textField == nameTextField {
            let name = nameTextField.text ?? ""
            delegate?.didUpdatePesonalName(cell: self, name: name)
        } else if textField == ageTextField {
            let age = Int(ageTextField.text ?? "") ?? 0
            delegate?.didUpdatePesonalAge(cell: self, age: age)
        }
    }
}

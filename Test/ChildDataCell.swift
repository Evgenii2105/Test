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
    
    private let nameChildContainer: UIView = {
        let nameChildContainer = UIView()
        nameChildContainer.backgroundColor = .white
        nameChildContainer.layer.borderColor = UIColor.lightGray.cgColor
        nameChildContainer.layer.borderWidth = 1.0
        nameChildContainer.layer.cornerRadius = 8.0
        nameChildContainer.translatesAutoresizingMaskIntoConstraints = false
        return nameChildContainer
    }()
    
    private let ageChildContainer: UIView = {
        let ageChildContainer = UIView()
        ageChildContainer.backgroundColor = .white
        ageChildContainer.layer.borderColor = UIColor.lightGray.cgColor
        ageChildContainer.layer.borderWidth = 1.0
        ageChildContainer.layer.cornerRadius = 8.0
        ageChildContainer.translatesAutoresizingMaskIntoConstraints = false
        return ageChildContainer
    }()
    
    private let childrenNameTextField: UITextField = {
        let ChildrenNameTextField = UITextField()
        ChildrenNameTextField.placeholder = "Введите имя"
        ChildrenNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return ChildrenNameTextField
    }()
    
    private let nameChildrenLabel: UILabel = {
        let nameChildrenLabel = UILabel()
        nameChildrenLabel.numberOfLines = 0
        nameChildrenLabel.text = "Имя"
        nameChildrenLabel.font = .preferredFont(forTextStyle: .footnote)
        nameChildrenLabel.lineBreakMode = .byWordWrapping
        nameChildrenLabel.textColor = .gray
        nameChildrenLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameChildrenLabel
    }()
    
    private let ageChildrenLabel: UILabel = {
        let ageChildrenLabel = UILabel()
        ageChildrenLabel.text = "Возраст"
        ageChildrenLabel.translatesAutoresizingMaskIntoConstraints = false
        ageChildrenLabel.font = .systemFont(ofSize: 24)
        ageChildrenLabel.textColor = .gray
        ageChildrenLabel.font = .preferredFont(forTextStyle: .footnote)
        return ageChildrenLabel
    }()
    
    private let childrenAgeTextField: UITextField = {
        let childrenAgeTextField = UITextField()
        childrenAgeTextField.placeholder = "Введите возраст"
        childrenAgeTextField.keyboardType = .numberPad
        childrenAgeTextField.translatesAutoresizingMaskIntoConstraints = false
        return childrenAgeTextField
    }()
    
    private let deleteChildrenButton: UIButton = {
        let deleteChildrenButton = UIButton()
        var configure = UIButton.Configuration.plain()
        configure.title = "Удалить"
        configure.baseForegroundColor = .systemBlue
        configure.background.cornerRadius = 15
        configure.background.backgroundColor = .systemBackground
        configure.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        deleteChildrenButton.translatesAutoresizingMaskIntoConstraints = false
        deleteChildrenButton.configuration = configure
        return deleteChildrenButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
        setupConstraints()
        configureTableText()
        
        deleteChildrenButton.addTarget(self, action: #selector(deleteChildren), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func deleteChildren(_ sender: UIButton) {
        delegate?.didTapDeleteButton(cell: self)
    }
    
    private func setupUI() {
        contentView.addSubview(nameChildContainer)
        contentView.addSubview(ageChildContainer)
        nameChildContainer.addSubview(nameChildrenLabel)
        nameChildContainer.addSubview(childrenNameTextField)
        ageChildContainer.addSubview(ageChildrenLabel)
        ageChildContainer.addSubview(childrenAgeTextField)
        contentView.addSubview(deleteChildrenButton)
        contentView.addSubview(separatorView)
    }
    
    private func configureTableText() {
        childrenNameTextField.delegate = self
        childrenAgeTextField.delegate = self
    }
    
    func configureCell(with data: Personal, shouldShowSeparator: Bool) {
        childrenNameTextField.text = data.name
        childrenAgeTextField.text = nil
        separatorView.isHidden = !shouldShowSeparator
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            nameChildContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameChildContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameChildContainer.trailingAnchor.constraint(equalTo: deleteChildrenButton.leadingAnchor, constant: -30),
            nameChildContainer.bottomAnchor.constraint(equalTo: ageChildContainer.topAnchor, constant: -16),
            
            nameChildrenLabel.topAnchor.constraint(equalTo: nameChildContainer.topAnchor, constant: 8),
            nameChildrenLabel.leadingAnchor.constraint(equalTo: nameChildContainer.leadingAnchor, constant: 8),
            nameChildrenLabel.trailingAnchor.constraint(equalTo: nameChildContainer.trailingAnchor, constant: -8),
            
            childrenNameTextField.topAnchor.constraint(equalTo: nameChildrenLabel.bottomAnchor, constant: 8),
            childrenNameTextField.leadingAnchor.constraint(equalTo: nameChildContainer.leadingAnchor, constant: 8),
            childrenNameTextField.trailingAnchor.constraint(equalTo: nameChildContainer.trailingAnchor, constant: -8),
            childrenNameTextField.bottomAnchor.constraint(equalTo: nameChildContainer.bottomAnchor, constant: -8),
            
            ageChildContainer.topAnchor.constraint(equalTo: nameChildContainer.bottomAnchor, constant: 16),
            ageChildContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ageChildContainer.trailingAnchor.constraint(equalTo: deleteChildrenButton.leadingAnchor, constant: -30),
            ageChildContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            ageChildrenLabel.topAnchor.constraint(equalTo: ageChildContainer.topAnchor, constant: 8),
            ageChildrenLabel.leadingAnchor.constraint(equalTo: ageChildContainer.leadingAnchor, constant: 8),
            ageChildrenLabel.trailingAnchor.constraint(equalTo: ageChildContainer.trailingAnchor, constant: -8),
            
            childrenAgeTextField.topAnchor.constraint(equalTo: ageChildrenLabel.bottomAnchor, constant: 8),
            childrenAgeTextField.leadingAnchor.constraint(equalTo: ageChildContainer.leadingAnchor, constant: 8),
            childrenAgeTextField.trailingAnchor.constraint(equalTo: ageChildContainer.trailingAnchor, constant: -8),
            childrenAgeTextField.bottomAnchor.constraint(equalTo: ageChildContainer.bottomAnchor, constant: -8),
            
            deleteChildrenButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -55),
            deleteChildrenButton.centerYAnchor.constraint(equalTo: nameChildContainer.centerYAnchor),
            deleteChildrenButton.widthAnchor.constraint(equalToConstant: 100),
            deleteChildrenButton.heightAnchor.constraint(equalToConstant: 40),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }
}

extension ChildDataCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        let maxLength = 30
        
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
        if textField == childrenNameTextField {
            let name = childrenNameTextField.text ?? ""
            delegate?.didUpdateChildName(cell: self, name: name)
        } else if textField == childrenAgeTextField {
            let age = Int(childrenAgeTextField.text ?? "") ?? 0
            delegate?.didUpdateChildAge(cell: self, age: age)
        }
    }
}

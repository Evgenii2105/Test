//
//  CreateCell.swift
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
    
    weak var delegate: CustomTableDelegate?
    
    private let myTextName: UITextField = {
        let myTextName = UITextField()
        myTextName.placeholder = "Введите имя"
        myTextName.translatesAutoresizingMaskIntoConstraints = false
        return myTextName
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
    
    private let titleLabelName: UILabel = {
        let titleLabelName = UILabel()
        titleLabelName.numberOfLines = 0
        titleLabelName.text = "Имя"
        titleLabelName.font = .systemFont(ofSize: 24)
        titleLabelName.font = .preferredFont(forTextStyle: .footnote)
        titleLabelName.adjustsFontSizeToFitWidth = false
        titleLabelName.lineBreakMode = .byWordWrapping
        titleLabelName.textColor = .gray
        titleLabelName.translatesAutoresizingMaskIntoConstraints = false
        return titleLabelName
    }()
    
    private let titleLabelAge: UILabel = {
        let titleLabelAge = UILabel()
        titleLabelAge.text = "Возраст"
        titleLabelAge.translatesAutoresizingMaskIntoConstraints = false
        titleLabelAge.font = .systemFont(ofSize: 24)
        titleLabelAge.textColor = .gray
        titleLabelAge.font = .preferredFont(forTextStyle: .footnote)
        return titleLabelAge
    }()
    
    private let myTextAge: UITextField = {
        let myTextAge = UITextField()
        myTextAge.placeholder = "Введите возраст"
        myTextAge.keyboardType = .numberPad
        myTextAge.translatesAutoresizingMaskIntoConstraints = false
        return myTextAge
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(nameDataContainer)
        contentView.addSubview(ageDataContainer)
        nameDataContainer.addSubview(titleLabelName)
        nameDataContainer.addSubview(myTextName)
        ageDataContainer.addSubview(titleLabelAge)
        ageDataContainer.addSubview(myTextAge)
        //        contentView.addSubview(titleLabelName)
        //        contentView.addSubview(myTextName)
        //        contentView.addSubview(titleLabelAge)
        //        contentView.addSubview(myTextAge)
        
        configureTableText()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: PersonalData) {
        myTextName.text = data.name.isEmpty ? "" : data.name
        myTextAge.text = data.age == 0 ? "" : "\(data.age)"
    }
    
    private func configureTableText() {
        myTextName.delegate = self
        myTextAge.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            nameDataContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameDataContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameDataContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameDataContainer.bottomAnchor.constraint(equalTo: ageDataContainer.topAnchor, constant: -8),
            
            titleLabelName.topAnchor.constraint(equalTo: nameDataContainer.topAnchor, constant: 8),
            titleLabelName.leadingAnchor.constraint(equalTo: nameDataContainer.leadingAnchor, constant: 8),
            titleLabelName.trailingAnchor.constraint(equalTo: nameDataContainer.trailingAnchor, constant: -8),
            titleLabelName.bottomAnchor.constraint(equalTo: myTextName.topAnchor, constant: -8),
            
            myTextName.topAnchor.constraint(equalTo: titleLabelName.bottomAnchor, constant: 6),
            myTextName.leadingAnchor.constraint(equalTo: nameDataContainer.leadingAnchor, constant: 8),
            myTextName.trailingAnchor.constraint(equalTo: nameDataContainer.trailingAnchor, constant: -8),
            myTextName.bottomAnchor.constraint(equalTo: nameDataContainer.bottomAnchor, constant: -4),
            
            ageDataContainer.topAnchor.constraint(equalTo: nameDataContainer.bottomAnchor, constant: 8),
            ageDataContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ageDataContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ageDataContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            titleLabelAge.topAnchor.constraint(equalTo: ageDataContainer.topAnchor, constant: 8),
            titleLabelAge.leadingAnchor.constraint(equalTo: ageDataContainer.leadingAnchor, constant: 8),
            titleLabelAge.trailingAnchor.constraint(equalTo: ageDataContainer.trailingAnchor, constant: -8),
            titleLabelAge.bottomAnchor.constraint(equalTo: myTextAge.topAnchor, constant: -8),
            
            myTextAge.topAnchor.constraint(equalTo: titleLabelAge.bottomAnchor, constant: 4),
            myTextAge.leadingAnchor.constraint(equalTo: ageDataContainer.leadingAnchor, constant: 8),
            myTextAge.trailingAnchor.constraint(equalTo: ageDataContainer.trailingAnchor, constant: -16),
            myTextAge.bottomAnchor.constraint(equalTo: ageDataContainer.bottomAnchor, constant: -8)
        ])
    }
}

extension PersonalDataCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 30
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
        
        if textField == myTextName {
            let name = myTextName.text ?? ""
            delegate?.didUpdatePesonalName(cell: self, name: name)
        } else if textField == myTextAge {
            let age = Int(myTextAge.text ?? "") ?? 0
            delegate?.didUpdatePesonalAge(cell: self, age: age)
        }
    }
}

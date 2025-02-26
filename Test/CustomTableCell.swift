//
//  CreateCell.swift
//  Test
//
//  Created by Евгений Фомичев on 19.02.2025.
//

import UIKit

class CustomTableCell: UITableViewCell { 
    
    static let cellIdentifier = "DataItemCell"
    
    private let myText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите имя"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let titleLabelName: UILabel = {
        let titleLabelName = UILabel()
        titleLabelName.numberOfLines = 0
        titleLabelName.text = "Имя"
        titleLabelName.font = .systemFont(ofSize: 24)
        titleLabelName.font = .preferredFont(forTextStyle: .footnote)
        titleLabelName.adjustsFontSizeToFitWidth = false
        titleLabelName.lineBreakMode = .byWordWrapping
        titleLabelName.translatesAutoresizingMaskIntoConstraints = false
        return titleLabelName
    }()
    
    private let titleLabelAge: UILabel = {
        let titleLabelAge = UILabel()
        titleLabelAge.text = "Возраст"
        titleLabelAge.translatesAutoresizingMaskIntoConstraints = false
        titleLabelAge.font = .systemFont(ofSize: 24)
        titleLabelAge.font = .preferredFont(forTextStyle: .footnote)
        return titleLabelAge
    }()
    
    private let myTextAge: UITextField = {
        let myTextAge = UITextField()
        myTextAge.placeholder = "Введите возраст"
        myTextAge.translatesAutoresizingMaskIntoConstraints = false
        return myTextAge
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabelName)
        contentView.addSubview(myText)
        contentView.addSubview(titleLabelAge)
        contentView.addSubview(myTextAge)
        
        configureTableText()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: Child) {
        
        titleLabelName.text = data.name
       // subtitleLabelName.text = "\(data.age)"
        
        print("добавление PersonalData")
        myText.placeholder = "Введите \(data.name)"
    }
    
    private func configureTableText() {
        myText.delegate = self
        myTextAge.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabelName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabelName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            myText.topAnchor.constraint(equalTo: titleLabelName.bottomAnchor, constant: 4),
            myText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            myText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleLabelAge.topAnchor.constraint(equalTo: myText.bottomAnchor, constant: 16),
            titleLabelAge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabelAge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            myTextAge.topAnchor.constraint(equalTo: titleLabelAge.bottomAnchor, constant: 4),
            myTextAge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            myTextAge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            myTextAge.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            
        ])
    }
}

extension CustomTableCell: UITextFieldDelegate {
    
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
}

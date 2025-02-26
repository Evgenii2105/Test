//
//  PersonalDataController.swift
//  Test
//
//  Created by Евгений Фомичев on 19.02.2025.
//

import UIKit

class PersonalDataController: UIViewController {
    
    private var containerConstraint: NSLayoutConstraint?
    
    private var tableDataSource = DataContainerImpl()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private let headerContainer: UIView = {
        let headerContainer = UIView()
        headerContainer.backgroundColor = .systemBackground
        return headerContainer
    }()
    
    private let footerButtonContainer: UIView = {
        let footerButtonContainer = UIView()
        footerButtonContainer.backgroundColor = .systemBackground
        return footerButtonContainer
    }()
    
    private let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "Персональные данные"
        headerLabel.font = .systemFont(ofSize: 16)
        headerLabel.font = .preferredFont(forTextStyle: .headline)
        headerLabel.textColor = .black
        return headerLabel
    }()
    
    private let footerButton: UIButton = {
        let footerButton = UIButton()
        footerButton.setTitle("Очистить", for: .normal)
        footerButton.tintColor = .red
        footerButton.setTitleColor(.red, for: .normal)
        footerButton.layer.borderColor = UIColor.red.cgColor
        footerButton.layer.borderWidth = 2
        footerButton.layer.cornerRadius = 25
        return footerButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        configureTableView()
        setupTableHeaderView()
        setupTableFooterView()
        setupConstaints()
        
        footerButton.addTarget(self, action: #selector(removeButton), for: .touchUpInside)
    }
    
    func setupTableHeaderView() {
        tableView.tableHeaderView = headerContainer
        headerContainer.addSubview(headerLabel)
        headerContainer.frame = CGRect(x: 0, y: 200, width: 250, height: 50)
        headerLabel.frame = CGRect(x: 10, y: 0, width: 600, height: 50)
    }
    
    func setupTableFooterView() {
        tableView.tableFooterView = footerButtonContainer
        footerButtonContainer.addSubview(footerButton)
        footerButtonContainer.frame = CGRect(x: 50, y: 400, width: 250, height: 50)
        footerButton.frame = CGRect(x: 15, y: 400, width: 250, height: 50)
    }
    
    func setupConstaints() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func removeButton(_ sender: UIButton) {
        print("кнопка нажата!!!!")
    }
    
    @objc
    private func moveContentUp(notification: NSNotification) {
        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            print("Ошибка")
            return
        }
        let keyBoardFrame = keyboardSize.cgRectValue
        let keyboardHeight = keyBoardFrame.height
        
        UIView.animate(withDuration: 0.3) {
            self.containerConstraint?.constant = -keyboardHeight
        }
    }
    
    @objc
    private func moveContentDown(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.containerConstraint?.constant = 0
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.cellIdentifier)
        tableView.register(ChildrenHeaderCell.self, forCellReuseIdentifier: ChildrenHeaderCell.cellIdentifier)
        tableView.register(ChildDataCell.self, forCellReuseIdentifier: ChildDataCell.cellIdentifier)
        tableView.allowsSelectionDuringEditing = true
    }
}


extension PersonalDataController: UITableViewDelegate, UITableViewDataSource,  headerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.personalArray.count + tableDataSource.children.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = tableDataSource.index(for: indexPath.row)
        
        switch data {
        case .personalData:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.cellIdentifier, for: indexPath) as? CustomTableCell else {
                print("выстаавляю персонал дата")
                return UITableViewCell()
            }
            return cell
            
            // cell.configure(with: tableItem)
            // return cell
            
        case .addChildren:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChildrenHeaderCell.cellIdentifier, for: indexPath) as? ChildrenHeaderCell else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            return cell
            
        case .children:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChildDataCell.cellIdentifier, for: indexPath) as? ChildDataCell else {
                return UITableViewCell()
            }
            let childIndex = indexPath.row - tableDataSource.personalArray.count
            cell.configure(with: tableDataSource.children[childIndex])
            
            return cell
        }
    }
    func tapAddChildren(name: String, age: Int) {
        
        let newChildData = Child(name: name, age: age)
        tableDataSource.children.append(newChildData)
        
        print("кнопка нажата через делегат")
        
        tableView.reloadData()
        print("Ребенок добавлен через делегат")
    }
}

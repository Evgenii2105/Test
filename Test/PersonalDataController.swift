//
//  PersonalDataController.swift
//  Test
//
//  Created by Евгений Фомичев on 19.02.2025.
//

import UIKit

class PersonalDataController: UIViewController {
    
    private var containerConstraint: NSLayoutConstraint?
    
    private var tableDataSource: DataContainer = DataContainerImpl()
    
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
        setupNotifications()
        updateClearButtonState()
        
        footerButton.addTarget(self, action: #selector(openAlert), for: .touchUpInside)
    }
    
    func setupTableHeaderView() {
        tableView.tableHeaderView = headerContainer
        headerContainer.addSubview(headerLabel)
        headerContainer.frame = CGRect(x: 0, y: 200, width: 250, height: 50)
        headerLabel.frame = CGRect(x: 0, y: 0, width: 600, height: 50)
    }
    
    func setupTableFooterView() {
        tableView.tableFooterView = footerButtonContainer
        footerButtonContainer.addSubview(footerButton)
        let footerHeight: CGFloat = 60
        let containerWidth = view.frame.width
        
        footerButtonContainer.frame = CGRect(
            x: 0,
            y: 0,
            width: containerWidth,
            height: footerHeight + 10
        )
        
        footerButton.frame = CGRect(
            x: (containerWidth - 250) / 2,
            y: 10,
            width: 250,
            height: 50)
    }
    
    func setupConstaints() {
        
        containerConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerConstraint!
        ])
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
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func moveContentDown(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.containerConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(moveContentUp),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(moveContentDown),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PersonalDataCell.self, forCellReuseIdentifier: PersonalDataCell.cellIdentifier)
        tableView.register(ChildrenHeaderCell.self, forCellReuseIdentifier: ChildrenHeaderCell.cellIdentifier)
        tableView.register(ChildDataCell.self, forCellReuseIdentifier: ChildDataCell.cellIdentifier)
        tableView.allowsSelectionDuringEditing = true
        tableView.separatorStyle = .none
    }
    
    private func updateClearButtonState() {
        footerButton.isEnabled = !tableDataSource.isDataEmpty
        footerButton.alpha = tableDataSource.isDataEmpty ? 0.5 : 1.0
    }
    
    @objc
    private func openAlert() {
        let alert = UIAlertController(title: "Вы уверены, что хотите сбросить данные?",
                                      message: "",
                                      preferredStyle: .alert)
        let resetButton = UIAlertAction(title: "Да",
                                        style: .destructive) { _ in
            
            self.tableView.endEditing(true)
            self.tableDataSource.clearPersonalData()
            self.tableDataSource.clearChildren()
            self.tableView.reloadData()
            self.updateClearButtonState()
        }
        
        let cancelButton = UIAlertAction(title: "Отмена",
                                         style: .cancel)
        alert.addAction(resetButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension PersonalDataController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.personalArray.count + tableDataSource.children.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = tableDataSource.index(for: indexPath.row)
        
        switch data {
        case .personalData:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonalDataCell.cellIdentifier, for: indexPath) as? PersonalDataCell else {
                return UITableViewCell()
            }
            
            cell.configureCellPersonal(with: tableDataSource.personalData)
            cell.delegate = self
            
            return cell
            
        case .addChildren:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChildrenHeaderCell.cellIdentifier, for: indexPath) as? ChildrenHeaderCell else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            
            let isAddButtonHidden = tableDataSource.children.count >= DataContainerImpl.limitChildren
            cell.setAddButtonVisibility(isHidden: isAddButtonHidden)
            
            return cell
            
        case .children:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChildDataCell.cellIdentifier, for: indexPath) as? ChildDataCell else {
                return UITableViewCell()
            }
            
            let childIndex = indexPath.row - tableDataSource.personalArray.count
            
            let shouldShowSeparator = childIndex < tableDataSource.children.count - 1
            
            cell.configureCell(with: tableDataSource.children[childIndex], shouldShowSeparator: shouldShowSeparator)
            
            cell.delegate = self
            return cell
        }
    }
    
    private func hideAddButton() {
        
        let indexPath = IndexPath(row: 1, section: 0)
        if let headerCell = tableView.cellForRow(at: indexPath) as? ChildrenHeaderCell {
            headerCell.setAddButtonVisibility(isHidden: true)
        }
    }
}

extension PersonalDataController: HeaderDelegate {
    
    func tapAddChildren(name: String, age: Int) {
        
        if tableDataSource.children.count < DataContainerImpl.limitChildren {
            
            let newChildren = Personal(namePeronal: "", agePersonal: 0, nameChild: "", ageChild: 0)
            
            tableDataSource.addChild(newChildren)
            
            let newIndexPath = IndexPath(row: tableDataSource.personalArray.count + tableDataSource.children.count - 1, section: 0)
            
            if tableDataSource.children.count > 1 {
                let indexPathToUpdate = IndexPath(row: newIndexPath.row - 1, section: 0)
                
                tableView.performBatchUpdates {
                    tableView.reloadRows(at: [indexPathToUpdate], with: .automatic)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            } else {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            if tableDataSource.children.count >= 5 {
                hideAddButton()
            }
            updateClearButtonState()
        } else {
            showAlert(title: "Error", message: "Добавление детей невозможно")
        }
    }
}

extension PersonalDataController: ChildDataCellDelegate {
    
    func didTapDeleteButton(cell: ChildDataCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return  }
        
        let childIndex = indexPath.row - tableDataSource.personalArray.count
        tableDataSource.removeChild(at: childIndex)
        
        tableView.performBatchUpdates {
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if tableDataSource.children.count > 0 {
                let newLastIndexPath =  IndexPath(row: tableDataSource.personalArray.count + tableDataSource.children.count - 1, section: 0)
                
                if indexPath != newLastIndexPath {
                    tableView.reloadRows(at: [newLastIndexPath], with: .automatic)
                }
            }
            updateClearButtonState()
        }
        
        if tableDataSource.children.count < DataContainerImpl.limitChildren {
            
            let headerIndexPath = IndexPath(row: 1, section: 0)
            if let headerCell = tableView.cellForRow(at: headerIndexPath) as? ChildrenHeaderCell {
                headerCell.setAddButtonVisibility(isHidden: false)
            }
        }
    }
    
    func didUpdateChildName(cell: ChildDataCell, name: String) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let childIndex = indexPath.row - tableDataSource.personalArray.count
        tableDataSource.updateChildName(at: childIndex, name: name)
        updateClearButtonState()
    }
    
    func didUpdateChildAge(cell: ChildDataCell, age: Int) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let childIndex = indexPath.row - tableDataSource.personalArray.count
        tableDataSource.updateChildAge(at: childIndex, age: age)
        updateClearButtonState()
    }
}

extension PersonalDataController: CustomTableDelegate {
    
    func didUpdatePesonalName(cell: PersonalDataCell, name: String) {
        
        tableDataSource.updatePersonalName(name: name)
        updateClearButtonState()
    }
    
    func didUpdatePesonalAge(cell: PersonalDataCell, age: Int) {
        
        tableDataSource.updatePersonalAge(age: age)
        updateClearButtonState()
    }
}

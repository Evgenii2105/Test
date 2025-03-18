//
//  PersonalDataController.swift
//  Test
//
//  Created by Евгений Фомичев on 19.02.2025.
//

import UIKit

class PersonalDataController: UIViewController {
    
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
        let footerButton = UIButton(type: .system)
        footerButton.setTitle("Очистить", for: .normal)
        footerButton.tintColor = .red
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
    }
    
    private func setupTableHeaderView() {
        tableView.tableHeaderView = headerContainer
        headerContainer.addSubview(headerLabel)
        headerContainer.frame = CGRect(x: 10,
                                       y: 200,
                                       width: 250,
                                       height: 50)
        headerLabel.frame = CGRect(x: 10,
                                   y: 0,
                                   width: 600,
                                   height: 50)
    }
    
    private func setupConstaints() {
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension PersonalDataController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.personalArray.count + tableDataSource.children.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = tableDataSource.index(for: indexPath.row)
        
        switch cellType {
        case .personalData:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonalDataCell.cellIdentifier, for: indexPath) as? PersonalDataCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: tableDataSource.personalData)
            cell.delegate = self
            
            return cell
            
        case .addChildren:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChildrenAddCell.cellIdentifier, for: indexPath) as? ChildrenAddCell else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            
            let isAddButtonHidden = tableDataSource.children.count >= DataContainerImpl.limitChildren
            
            cell.configure(isAddButtonHidden: isAddButtonHidden)
            
            return cell
            
        case .children:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChildDataCell.cellIdentifier, for: indexPath) as? ChildDataCell else {
                return UITableViewCell()
            }
            
            let childIndex = indexPath.row - tableDataSource.personalArray.count
            
            let shouldShowSeparator = childIndex < tableDataSource.children.count - 1
            
            cell.configure(with: tableDataSource.children[childIndex], shouldShowSeparator: shouldShowSeparator)
            
            cell.delegate = self
            return cell
        }
    }
    
    private func changeAddButtonVisibility(isHidden: Bool) {
        
        let indexPath = IndexPath(row: DataContainerImpl.Section.addChildren.rawValue, section: 0)
        if let headerCell = tableView.cellForRow(at: indexPath) as? ChildrenAddCell {
            headerCell.configure(isAddButtonHidden:isHidden)
        }
    }
}

extension PersonalDataController: HeaderDelegate {
    
    func tapAddChildren(name: String, age: Int) {
        
        tableView.endEditing(true)
        
        guard tableDataSource.children.count < DataContainerImpl.limitChildren else {
            return showAlert(title: "Error", message: "Добавление детей невозможно"
            )}
        
        let newChildren = Personal(name: name, age: age)
        
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
        
        if tableDataSource.children.count >= DataContainerImpl.limitChildren {
            changeAddButtonVisibility(isHidden: true)
        }
        updateClearButtonState()
    }
}

extension PersonalDataController: ChildDataCellDelegate {
    
    func didTapDeleteButton(cell: ChildDataCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return  }
        
        let childIndex = indexPath.row - tableDataSource.personalArray.count
        tableDataSource.removeChild(at: childIndex)
        let newLastIndexPath =  IndexPath(row: tableDataSource.personalArray.count + tableDataSource.children.count - 1, section: 0)
        let isLastCell = indexPath != newLastIndexPath
        let shouldReloadLastCell = tableDataSource.children.count > 0
        
        tableView.performBatchUpdates {
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if isLastCell && shouldReloadLastCell {
                tableView.reloadRows(at: [newLastIndexPath], with: .automatic)
            }
            updateClearButtonState()
        }
        
        changeAddButtonVisibility(isHidden: false)
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

extension PersonalDataController {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PersonalDataCell.self, forCellReuseIdentifier: PersonalDataCell.cellIdentifier)
        tableView.register(ChildrenAddCell.self, forCellReuseIdentifier: ChildrenAddCell.cellIdentifier)
        tableView.register(ChildDataCell.self, forCellReuseIdentifier: ChildDataCell.cellIdentifier)
        tableView.separatorStyle = .none
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func setupTableFooterView() {
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
        
        footerButton.addTarget(self, action: #selector(showClearDataAlert), for: .touchUpInside)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let keyboardHeight = keyboardSize.height
        tableView.contentInset = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: keyboardHeight,
                                              right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    private func updateClearButtonState() {
        let isEnabled = !tableDataSource.isDataEmpty
        footerButton.isEnabled = isEnabled
        
        let titleColor = isEnabled ? UIColor.red : UIColor.gray
        footerButton.setTitleColor(titleColor, for: .normal)
        footerButton.layer.borderColor = titleColor.cgColor
    }
    
    private func showAlert(
        title: String,
        message: String,
        style: UIAlertController.Style = .alert,
        actions: [UIAlertAction] = []
    ) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: style)
        
        for action in actions {
            alert.addAction(action)
        }
        
        if actions.isEmpty {
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
        }
        
        present(alert, animated: true)
    }
    
    @objc
    private func showClearDataAlert() {
        
        let resetButton = UIAlertAction(title: "Да", style: .destructive) { _ in
            self.tableView.endEditing(true)
            self.tableDataSource.clearPersonalData()
            self.tableDataSource.clearChildren()
            self.tableView.reloadData()
            self.updateClearButtonState()
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel)
        
        showAlert(
            title: "Вы уверены, что хотите сбросить данные?",
            message: "",
            actions: [resetButton, cancelButton]
        )
    }
}

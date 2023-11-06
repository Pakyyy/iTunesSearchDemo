//
//  ItemListViewController.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 6/11/2023.
//

import Foundation
import UIKit

class ItemListViewController<E: RawRepresentable & CaseIterable>: UIViewController, UITableViewDelegate, UITableViewDataSource where E.RawValue == String {

    
    let item: E
    let completionHandler: ((E) -> Void)?
    
    private lazy var itemsListTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()

    init(
        with item: E,
        completionHandler: ((E) -> Void)?
    ) {
        self.item = item
        self.completionHandler = completionHandler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("No init(coder:) for ItemListViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(itemsListTableView)
        itemsListTableView.translatesAutoresizingMaskIntoConstraints = false
        itemsListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        itemsListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        itemsListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        itemsListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return E.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let currentModel: E = Array(E.allCases)[indexPath.row]
        cell.textLabel?.text = currentModel.rawValue.localized()
        cell.accessoryType = .none
        
        if currentModel == self.item {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentModel: E = Array(E.allCases)[indexPath.row]
        guard currentModel != self.item else { return }
        
        completionHandler?(currentModel)
    }
}

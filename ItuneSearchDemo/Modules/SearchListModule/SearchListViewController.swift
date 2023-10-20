//
//  SearchListViewController.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import UIKit

final class SearchListViewController: UIViewController {
    private struct Constants {
        static let commonMargin: CGFloat = 8.0
        static let commonSpacing: CGFloat = 4.0

        static let tableViewCellHeight: CGFloat = 120.0
    }
    
    // MARK: - Dependencies
    private let viewModel: SearchListViewModelProtocol
    
    private lazy var tracksTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: TrackTableViewCell.identifier)
        return tableView
    }()
    
    init(viewModel: SearchListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupSubviews()
        makeConstraints()
        setupBinding()
        
        viewModel.input.onViewDidLoad.value = ()
    }
    
    private func setupNavigationItem() {
        let languageSettingButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"setting_icon"), style: .plain, target: self, action: #selector(tappedSettingButton))
        self.navigationItem.rightBarButtonItem = languageSettingButton
    }
    
    private func setupSubviews() {
//        self.title = "Search"
        view.backgroundColor = .white
        
        view.addSubview(tracksTableView)
    }
    
    private func makeConstraints() {
        // Constraints of rateConvertorTableView
        tracksTableView.translatesAutoresizingMaskIntoConstraints = false
        tracksTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constants.commonMargin).isActive = true
        tracksTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.commonMargin).isActive = true
        tracksTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.commonMargin).isActive = true
        tracksTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.commonMargin).isActive = true
    }
    
    private func setupBinding() {
        viewModel.output.tracks.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tracksTableView.reloadData()
            }
        }
    }
}

extension SearchListViewController {
    @objc private func tappedSettingButton() {
        let settingViewController = SettingViewController()
        settingViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension SearchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableViewCellHeight
    }
}

// MARK: - UITableViewDataSource
extension SearchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.output.tracks.value.count == 0 {
            tableView.setEmptyMessage("No Result yet...")
        } else {
            tableView.restoreEmptyMessage()
        }
        
        return viewModel.output.tracks.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.identifier, for: indexPath) as? TrackTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(with: viewModel.output.tracks.value[indexPath.row])
    
        return cell
    }
}

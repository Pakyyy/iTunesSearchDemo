//
//  FavouriteListViewController.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import UIKit

final class FavouriteListViewController: UIViewController {
    private struct Constants {
        static let commonMargin: CGFloat = 8.0
        static let commonSpacing: CGFloat = 4.0
        static let tableViewCellHeight: CGFloat = 120.0
        static let commonCornerRadius: CGFloat = 8.0
    }
    
    // MARK: - Dependencies
    private let viewModel: FavouriteListViewModelProtocol
    
    private lazy var tracksTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: TrackTableViewCell.identifier)
        return tableView
    }()
    
    init(viewModel: FavouriteListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        makeConstraints()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.input.onViewDidAppear.value = ()
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        view.addSubview(tracksTableView)
    }
    
    private func makeConstraints() {
        // Constraints of tracksTableView
        tracksTableView.translatesAutoresizingMaskIntoConstraints = false
        tracksTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constants.commonMargin).isActive = true
        tracksTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.commonMargin).isActive = true
        tracksTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.commonMargin).isActive = true
        tracksTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.commonMargin).isActive = true
    }
    
    private func setupBinding() {
        viewModel.output.tracks.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tracksTableView.reloadData()
                // Show the scroll indicators to indicate that the list has been updated
                self?.tracksTableView.flashScrollIndicators()
            }
        }
        
        viewModel.output.currentLanguage.bindAndFire { [weak self] _ in
            DispatchQueue.main.async {
                self?.setupLanguage()
            }
        }
    }
    
    private func setupLanguage() {
        self.title = "Favourite".localized()
        tracksTableView.reloadData()
    }
    
    private func showRemoveFavouriteDialog(for index: Int) {
        let dialog: UIAlertController = UIAlertController(
            title: "Remove from Favourite".localized(),
            message: "Would you like to remove this track from favourite?".localized(),
            preferredStyle: UIAlertController.Style.alert
        )

        dialog.addAction(UIAlertAction(
            title: "Remove".localized(),
            style: UIAlertAction.Style.default,
            handler: { [weak self] _ in
                self?.viewModel.input.onSelectedRow.value = index
            }
        ))
        dialog.addAction(UIAlertAction(
            title: "Cancel".localized(),
            style: UIAlertAction.Style.cancel,
            handler: nil
        ))

        self.present(dialog, animated: true)
    }
}

extension FavouriteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showRemoveFavouriteDialog(for: indexPath.row)
    }
}

extension FavouriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.output.tracks.value.count == 0 {
            tableView.setEmptyMessage("No Favourite yet...".localized())
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

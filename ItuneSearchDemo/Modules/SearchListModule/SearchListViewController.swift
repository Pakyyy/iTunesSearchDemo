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
        static let headerHeight: CGFloat = 50.0
        static let tableViewCellHeight: CGFloat = 120.0
        static let commonCornerRadius: CGFloat = 8.0
        static let loadingViewDimension: CGFloat = 150.0
        static let loadingSpinnerDimension: CGFloat = 90.0
    }
    
    // MARK: - Dependencies
    private let viewModel: SearchListViewModelProtocol
    
    private lazy var searchBar: UISearchBar = {
        let view: UISearchBar = UISearchBar()
        view.delegate = self
        return view
    }()
    
    private let headerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var countryButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tappedCountryButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var mediaTypeButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tappedMediaTypeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var tracksTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: TrackTableViewCell.identifier)
        return tableView
    }()
    
    private let loadingContainerView: UIStackView = {
        let view: UIStackView = UIStackView()
        view.backgroundColor = .lightGray
        view.axis = .vertical
        view.alignment = .center
        view.layoutMargins = UIEdgeInsets(
            top: Constants.commonMargin * 2,
            left: Constants.commonMargin,
            bottom: Constants.commonMargin,
            right: Constants.commonMargin
        )
        view.isLayoutMarginsRelativeArrangement = true
        view.layer.cornerRadius = Constants.commonCornerRadius
        view.isHidden = true
        return view
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let view: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        view.color = .black
        view.startAnimating()
        return view
    }()
    
    private let loadingLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20.0)
        return label
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
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(tracksTableView)
        headerView.addSubview(countryButton)
        headerView.addSubview(mediaTypeButton)
        tracksTableView.tableHeaderView = headerView
        view.addSubview(loadingContainerView)
        loadingContainerView.addArrangedSubview(loadingSpinner)
        loadingContainerView.addArrangedSubview(loadingLabel)
    }
    
    private func setupLanguage() {
        self.title = "Search".localized()
        searchBar.placeholder = "Search for track...".localized()
        countryButton.setTitle("Country Filter".localized(), for: .normal)
        mediaTypeButton.setTitle("Media Filter".localized(), for: .normal)
        loadingLabel.text = "Loading...".localized()
        tracksTableView.reloadData()
    }
    
    private func makeConstraints() {
        // Constrainst of searchBar
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constants.commonMargin).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.commonMargin).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.commonMargin).isActive = true
        
        // Constraints of headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: Constants.headerHeight).isActive = true
        
        // Constraints of countryButton
        countryButton.translatesAutoresizingMaskIntoConstraints = false
        countryButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        countryButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.commonMargin).isActive = true
        countryButton.widthAnchor.constraint(equalTo: mediaTypeButton.widthAnchor).isActive = true
        
        // Constraints of mediaTypeButton
        mediaTypeButton.translatesAutoresizingMaskIntoConstraints = false
        mediaTypeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        mediaTypeButton.leadingAnchor.constraint(equalTo: countryButton.trailingAnchor, constant: Constants.commonSpacing).isActive = true
        mediaTypeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Constants.commonMargin).isActive = true
        
        // Constraints of tracksTableView
        tracksTableView.translatesAutoresizingMaskIntoConstraints = false
        tracksTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Constants.commonSpacing).isActive = true
        tracksTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.commonMargin).isActive = true
        tracksTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.commonMargin).isActive = true
        tracksTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.commonMargin).isActive = true
        
        // Constraints of loadingContainerView
        loadingContainerView.translatesAutoresizingMaskIntoConstraints = false
        loadingContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loadingContainerView.heightAnchor.constraint(equalToConstant: Constants.loadingViewDimension).isActive = true
        loadingContainerView.widthAnchor.constraint(equalToConstant: Constants.loadingViewDimension).isActive = true
        
        // Constraints of loadingSpinner
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.heightAnchor.constraint(equalToConstant: Constants.loadingSpinnerDimension).isActive = true
        loadingSpinner.widthAnchor.constraint(equalToConstant: Constants.loadingSpinnerDimension).isActive = true
        
        // Constraints of loadingLabel
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupBinding() {
        viewModel.output.tracks.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tracksTableView.reloadData()
                // Show the scroll indicators to indicate that the list has been updated
                self?.tracksTableView.flashScrollIndicators()
            }
        }
        
        viewModel.output.isLoading.bind { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loadingContainerView.isHidden = !isLoading
            }
        }
        
        // TODO: error
        viewModel.output.error.bind { _ in
            print("error")
        }
        
        viewModel.output.filterNavigationEvent.bind { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .country(let selectedCountry):
                self.navigateToCountryList(with: selectedCountry)
            case .mediaType(let selectedMediaType):
                self.navigateToMediaTypeList(with: selectedMediaType)
            case .none:
                break
            }
        }
        
        // Subscribe to language change, we could create subclass to every UI class to subscribe to lanauge change / refresh the whole app to show updated language, according to the project size / structure
        viewModel.output.currentLanguage.bindAndFire { [weak self] _ in
            DispatchQueue.main.async {
                self?.setupLanguage()
            }
        }
    }
}

extension SearchListViewController {
    @objc private func tappedSettingButton() {
        navigateToSettingView()
    }
    
    @objc private func tappedCountryButton() {
        viewModel.input.onCountryButtonClicked.value = ()
    }
    
    @objc private func tappedMediaTypeButton() {
        viewModel.input.onMediaTypeButtonClicked.value = ()
    }
    
    private func showFavouriteDialog(for index: Int) {
        let dialog: UIAlertController = UIAlertController(
            title: "Add to Favourite".localized(),
            message: "Would you like to favourite this track?".localized(),
            preferredStyle: UIAlertController.Style.alert
        )

        dialog.addAction(UIAlertAction(
            title: "Add".localized(),
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

// MARK: - Navigation
extension SearchListViewController {
    private func navigateToSettingView() {
        let settingViewController: ItemListViewController<Language> = ItemListViewController<Language>(
            with: viewModel.output.currentLanguage.value,
            completionHandler: { newSelectedLanguage in
                self.viewModel.input.onSelectedLanguage.value = newSelectedLanguage
                self.navigationController?.popViewController(animated: true)
            }
        )
        
        settingViewController.hidesBottomBarWhenPushed = true
        settingViewController.title = "Language".localized()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    private func navigateToCountryList(with selectedCountry: Country) {
        let countryListViewController: ItemListViewController<Country> = ItemListViewController<Country>(
            with: selectedCountry,
            completionHandler: { newSelectedCountry in
                self.viewModel.input.onSelectedCountry.value = newSelectedCountry
                self.navigationController?.popViewController(animated: true)
            }
        )
        
        countryListViewController.hidesBottomBarWhenPushed = true
        countryListViewController.title = "Country".localized()
        self.navigationController?.pushViewController(countryListViewController, animated: true)
    }
    
    private func navigateToMediaTypeList(with selectedMediaType: MediaType) {
        let mediaTypeListViewController: ItemListViewController<MediaType> = ItemListViewController<MediaType>(
            with: selectedMediaType,
            completionHandler: { newSelectedMediaType in
                self.viewModel.input.onSelectedMediaType.value = newSelectedMediaType
                self.navigationController?.popViewController(animated: true)
            }
        )
        
        mediaTypeListViewController.hidesBottomBarWhenPushed = true
        mediaTypeListViewController.title = "Media Type".localized()
        self.navigationController?.pushViewController(mediaTypeListViewController, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension SearchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableViewCellHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewModel.output.tracks.value.count > 0 else { return }
        
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset

        // Fetch data when page reach the page end
        if distanceFromBottom < height {
            viewModel.input.onPageReachedEnd.value = ()
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showFavouriteDialog(for: indexPath.row)
    }
}

// MARK: - UITableViewDataSource
extension SearchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.output.tracks.value.count == 0 {
            tableView.setEmptyMessage("No Result yet...".localized())
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

// MARK: - UISearchBarDelegate
extension SearchListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.input.onSearchTextDidChange.value = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.onSearchBarCancelButtonClicked.value = ()
        searchBar.resignFirstResponder()
    }
}

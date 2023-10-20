//
//  TrackTableViewCell.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import UIKit

final class TrackTableViewCell: UITableViewCell {
    private struct Constants {
        static let commonMargin: CGFloat = 8.0
        static let commonSpacing: CGFloat = 4.0
    }
    
    private let containerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // TODO: artwork
    
    private let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset both labels
        nameLabel.text = nil
        artistNameLabel.text = nil
        albumNameLabel.text = nil
    }
    
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(artistNameLabel)
        containerView.addSubview(albumNameLabel)
    }
    
    private func makeConstraints() {
        // Constraints of containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        // Constraints of nameLabel
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.commonMargin).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.commonMargin).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.commonMargin).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Constraints of artistNameLabel
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.commonSpacing).isActive = true
        artistNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.commonMargin).isActive = true
        artistNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.commonMargin).isActive = true
        artistNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        albumNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: Constants.commonSpacing).isActive = true
        albumNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.commonMargin).isActive = true
        albumNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.commonMargin).isActive = true
        albumNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

extension TrackTableViewCell {
    func setupCell(with model: Track) {
        nameLabel.text = model.name
        artistNameLabel.text = model.artistName
        albumNameLabel.text = model.albumName
    }
}

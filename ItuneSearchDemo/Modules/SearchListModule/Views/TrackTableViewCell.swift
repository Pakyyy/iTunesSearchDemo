//
//  TrackTableViewCell.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import UIKit
import SDWebImage

final class TrackTableViewCell: UITableViewCell {
    private struct Constants {
        static let commonMargin: CGFloat = 8.0
        static let commonSpacing: CGFloat = 4.0
        
        static let artworkDimension: CGFloat = 104.0
        static let labelHeight: CGFloat = 26.0
        static let primaryFontSize: CGFloat = 24.0
        static let secondaryFontSize: CGFloat = 16.0
    }
    
    private let containerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let view: UIActivityIndicatorView = UIActivityIndicatorView()
        view.startAnimating()
        return view
    }()
    
    // ImageView of track's artwork
    private let trackImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.font = label.font.withSize(Constants.primaryFontSize)
        label.textColor = .darkText
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.font = label.font.withSize(Constants.secondaryFontSize)
        label.textColor = .darkGray
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.font = label.font.withSize(Constants.secondaryFontSize)
        label.textColor = .darkGray
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
        // Reset all views and labels
        loadingSpinner.startAnimating()
        trackImageView.image = nil
        nameLabel.text = nil
        artistNameLabel.text = nil
        albumNameLabel.text = nil
    }
    
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(trackImageView)
        containerView.addSubview(loadingSpinner)
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
        
        // Constraints of trackImagerView
        trackImageView.translatesAutoresizingMaskIntoConstraints = false
        trackImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.commonMargin).isActive = true
        trackImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        trackImageView.widthAnchor.constraint(equalToConstant: Constants.artworkDimension).isActive = true
        trackImageView.heightAnchor.constraint(equalToConstant: Constants.artworkDimension).isActive = true
        
        // Constraints of loadingSpinner
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.centerXAnchor.constraint(equalTo: trackImageView.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: trackImageView.centerYAnchor).isActive = true
        
        // Constraints of nameLabel
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.commonMargin).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: trackImageView.trailingAnchor, constant: Constants.commonMargin).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.commonMargin).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight).isActive = true
        
        // Constraints of artistNameLabel
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.commonSpacing).isActive = true
        artistNameLabel.leadingAnchor.constraint(equalTo: trackImageView.trailingAnchor, constant: Constants.commonMargin).isActive = true
        artistNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.commonMargin).isActive = true
        artistNameLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight).isActive = true
        
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        albumNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: Constants.commonSpacing).isActive = true
        albumNameLabel.leadingAnchor.constraint(equalTo: trackImageView.trailingAnchor, constant: Constants.commonMargin).isActive = true
        albumNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.commonMargin).isActive = true
        albumNameLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight).isActive = true
    }
}

extension TrackTableViewCell {
    func setupCell(with model: Track) {
        if let imageUrlString = model.albumArtworkUrl {
            trackImageView.sd_setImage(
                with: URL(string: imageUrlString),
                completed: { [weak self] _ ,_ ,_ ,_ in
                    // Stop the loading spinner when fetching image is completed
                    self?.loadingSpinner.stopAnimating()
            })
        }
        
        nameLabel.text = model.name
        artistNameLabel.text = model.artistName
        albumNameLabel.text = model.albumName
    }
}

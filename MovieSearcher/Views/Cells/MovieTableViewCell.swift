//
//  MovieTableViewCell.swift
//  MovieSearcher
//
//  Created by MacBook on 29.01.2024.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    //MARK: UI elements
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemOrange
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 3
        return label
    }()
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .top
        return stackView
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    //MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    //MARK: Private methods
    private func setupSubview() {
        contentView.addSubview(mainStackView)
        infoStackView.addArrangeSubviews([idLabel, nameLabel, descriptionLabel])
        mainStackView.addArrangeSubviews([movieImageView, infoStackView])
        
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
}

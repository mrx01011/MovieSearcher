//
//  MovieTableViewCell.swift
//  MovieSearcher
//
//  Created by MacBook on 29.01.2024.
//

import UIKit
import Kingfisher

final class MovieTableViewCell: UITableViewCell {
    //MARK: UI elements
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        imageView.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
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
        stackView.distribution = .fillProportionally
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
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        idLabel.text = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
    }
    //MARK: Private methods
    private func setupSubviews() {
        contentView.addSubview(mainStackView)
        infoStackView.addArrangeSubviews([idLabel, nameLabel, descriptionLabel])
        mainStackView.addArrangeSubviews([movieImageView, infoStackView])
        
        NSLayoutConstraint.activate([
            movieImageView.heightAnchor.constraint(equalToConstant: 100),
            movieImageView.widthAnchor.constraint(equalToConstant: 100),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    //MARK: Internal methods
    func configureCell(with model: Movie) {
        movieImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(model.posterPath)"))
        idLabel.text = "\(model.id)"
        nameLabel.text = model.title
        descriptionLabel.text = model.overview
    }
}

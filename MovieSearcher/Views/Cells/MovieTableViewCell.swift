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
        setupSubview()
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
    private func setupSubview() {
        contentView.addSubview(mainStackView)
        infoStackView.addArrangeSubviews([idLabel, nameLabel, descriptionLabel])
        mainStackView.addArrangeSubviews([movieImageView, infoStackView])
        
        movieImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
    //MARK: Internal methods
    func configureCell(with model: Movie) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.movieImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(model.posterPath)"))
            self.idLabel.text = "\(model.id)"
            self.nameLabel.text = model.title
            self.descriptionLabel.text = model.overview
        }
    }
}

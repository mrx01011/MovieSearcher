//
//  MovieTableViewCell.swift
//  MovieSearcher
//
//  Created by MacBook on 29.01.2024.
//

import UIKit
import Kingfisher
import SnapKit

final class MovieTableViewCell: UITableViewCell {
    //MARK: UI elements
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(100)
        }
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
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
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
        return stackView
    }()
    //MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        defaultConfigurations()
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
        ImageCache.default.clearMemoryCache()
    }
    //MARK: Private methods
    private func defaultConfigurations() {
        backgroundColor = .white
    }
    
    private func setupSubviews() {
        contentView.addSubview(mainStackView)
        infoStackView.addArrangeSubviews([idLabel, nameLabel, descriptionLabel])
        mainStackView.addArrangeSubviews([movieImageView, infoStackView])
        
        mainStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16).priority(.high)
        }
    }
    //MARK: Internal methods
    func configureCell(with model: Movie) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            movieImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(model.posterPath)"))
            idLabel.text = "\(model.id)"
            nameLabel.text = model.title
            descriptionLabel.text = model.overview
        }
    }
}

//
//  DetailMovieVC.swift
//  MovieSearcher
//
//  Created by MacBook on 29.01.2024.
//

import UIKit

final class DetailMovieVC: UIViewController {
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Release date"
        return label
    }()
    private let dateTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    private let ratingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "⭐️ Rating"
        return label
    }()
    private let ratingTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    private let popularityTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "❤️ Popularity"
        return label
    }()
    private let popularityTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    private let genresTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "🎭 Genres"
        return label
    }()
    private let genresTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Description"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fill
        return stackView
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    //MARK: Initialization
    init(with movie: Movie, genres: [Genre]) {
        super.init(nibName: nil, bundle: nil)
        configureView(with: movie, genres: genres)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        defaultConfigurations()
    }
    //MARK: Private methods
    private func defaultConfigurations() {
        view.backgroundColor = .white
    }
    
    private func setupUI() {
        view.addSubview(descriptionTitleLabel)
        view.addSubview(descriptionTextLabel)
        view.addSubview(mainStackView)
        infoStackView.addArrangeSubviews([dateTitleLabel, dateTextLabel, ratingTitleLabel, ratingTextLabel, popularityTitleLabel, popularityTextLabel, genresTitleLabel, genresTextLabel])
        mainStackView.addArrangeSubviews([movieImageView, infoStackView])
        //imageView constraints
        movieImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        //mainStack constraints
        mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        //description title constraints
        descriptionTitleLabel.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 10).isActive = true
        descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        descriptionTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        //description text constraints
        descriptionTextLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10).isActive = true
        descriptionTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        descriptionTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        descriptionTextLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = false
    }
    
    private func configureView(with model: Movie, genres: [Genre]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.movieImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(model.posterPath)"))
            self.title = model.title
            self.dateTextLabel.text = model.releaseDate
            self.ratingTextLabel.text = String(format: "%.01f", model.voteAverage)
            self.popularityTextLabel.text = "\(Int(model.popularity))"
            self.descriptionTextLabel.text = model.overview
            let genreNames: [String] = model.genreIDS.compactMap { genreID in
                return genres.first { $0.id == genreID }?.name
            }
            let genresText = genreNames.joined(separator: ", ")
            self.genresTextLabel.text = genresText
        }
    }
}

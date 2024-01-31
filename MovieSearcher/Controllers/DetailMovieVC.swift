//
//  DetailMovieVC.swift
//  MovieSearcher
//
//  Created by MacBook on 29.01.2024.
//

import UIKit
import SnapKit

final class DetailMovieVC: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    private let descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
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
        contentView.backgroundColor = .white
        title = "Details"
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
            $0.height.equalToSuperview().priority(250)
        }
        //backdrop
        contentView.addSubview(backdropImageView)
        backdropImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(250)
        }
        //poster
        backdropImageView.addSubview(movieImageView)
        movieImageView.snp.makeConstraints {
            $0.top.equalTo(backdropImageView.snp.centerY)
            $0.leading.equalToSuperview().offset(Constants.Offsets.sidePadding)
            $0.height.equalTo(150)
            $0.width.equalTo(100)
        }
        //title
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(movieImageView.snp.bottom).offset(Constants.Offsets.verticalSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.Offsets.sidePadding)
        }
        //info
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(Constants.Offsets.verticalSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.Offsets.sidePadding)
        }
        //description
        contentView.addSubview(descriptionTextLabel)
        descriptionTextLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(Constants.Offsets.verticalSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.Offsets.sidePadding)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureView(with model: Movie, genres: [Genre]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let genreNames: [String] = model.genreIDS.compactMap { genreID in
                return genres.first { $0.id == genreID }?.name
            }
            let genresText = genreNames.joined(separator: ", ")
            
            self.movieImageView.kf.setImage(with: URL(string: Constants.baseURL + model.posterPath))
            self.backdropImageView.kf.setImage(with: URL(string: Constants.baseURL + model.backdropPath))
            self.nameLabel.text = model.title
            self.infoLabel.text = genresText + " • " + model.releaseDate + " • ⭐️ " + String(format: "%.01f", model.voteAverage) + " •  ❤️ " + "\(Int(model.popularity))"
            self.descriptionTextLabel.text = model.overview
        }
    }
}
//MARK: - Constants
extension DetailMovieVC {
    enum Constants {
        static let baseURL = "https://image.tmdb.org/t/p/w500"
        enum Offsets {
            static let sidePadding = 16
            static let verticalSpacing = 10
        }
    }
}

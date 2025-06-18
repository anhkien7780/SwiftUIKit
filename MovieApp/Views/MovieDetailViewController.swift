//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Admin on 6/16/25.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {
    
    
    
    private let movieDetailViewModel: MovieDetailViewModel
    
    init(movieDetailViewModel: MovieDetailViewModel) {
        self.movieDetailViewModel = movieDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movie = movieDetailViewModel.selectedMovie!
        
        self.navigationItem.hidesBackButton = true
        
        view.backgroundColor = .black
        
        let topAppBarView = TopAppBarView()
        let backgroundView = MovieBackgroundView(backdropPath: movie.backdropPath ?? "", rate: "\(movie.voteAverage)")
        
        
        let posterImageView = UIImageView()
        let fullURL = "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")"
        posterImageView.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: "SpiderMan"))
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 16
        posterImageView.clipsToBounds = true
        
        let movieTitleLabel: UILabel = {
            let label = UILabel()
            label.text = movie.originalTitle
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textColor = .white
            return label
        }()
        
        let releaseDate = movie.releaseDate
        let releaseYear = releaseDate.split(separator: "-")[0]
        let descriptionsView = RowView(arrangedSubViews: [
            IconTitleView(imageNamed: "CalendarBlank", labelTitle: String(releaseYear), iconTintColor: .gray, titleTextColor: .gray),
            Divider(axis: .verical),
            IconTitleView(imageNamed: "Clock", labelTitle: "\(movie.runtime) Minutes", iconTintColor: .gray, titleTextColor: .gray),
            Divider(axis: .verical),
            IconTitleView(imageNamed: "Ticket", labelTitle: movie.genres[0].name, iconTintColor: .gray, titleTextColor: .gray),
        ])
        
        let overviewView: UILabel = {
            let label = UILabel()
            label.text = movie.overview
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .white
            return label
        }()
        
        descriptionsView.setSpacing(by: 4)
        
        
        topAppBarView.onBackTapped = {
            [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        topAppBarView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionsView.translatesAutoresizingMaskIntoConstraints = false
        overviewView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topAppBarView)
        view.addSubview(backgroundView)
        view.addSubview(posterImageView)
        view.addSubview(movieTitleLabel)
        view.addSubview(descriptionsView)
        view.addSubview(overviewView)
        
        NSLayoutConstraint.activate([
            topAppBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topAppBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topAppBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topAppBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backgroundView.topAnchor.constraint(equalTo: topAppBarView.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.heightAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 9.0/16.0),
            
            posterImageView.centerYAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            
            movieTitleLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 10),
            movieTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            movieTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            descriptionsView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 30),
            descriptionsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            overviewView.topAnchor.constraint(equalTo: descriptionsView.bottomAnchor, constant: 30),
            overviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            overviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            
        ])
        
        
        
    }
}



enum Axis{
    case verical
    case horizontal
}

class Divider: UIView {
    private let strokeSize: CGFloat
    private let axis: Axis
    
    init(axis: Axis, strokeSize: CGFloat = 1.0, strokeColor: UIColor = .lightGray) {
        self.axis = axis
        self.strokeSize = strokeSize
        super.init(frame: .zero)
        
        backgroundColor = strokeColor
        translatesAutoresizingMaskIntoConstraints = false
        
        // Áp dụng constraint tự động theo hướng
        NSLayoutConstraint.activate([
            axis == .horizontal
            ? heightAnchor.constraint(equalToConstant: strokeSize)
            : widthAnchor.constraint(equalToConstant: strokeSize)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MovieBackgroundView: UIView {
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 12
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private let paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let ratingLabel: IconTitleView = {
        let view = IconTitleView()
        view.backgroundColor = .clear
        view.setIconTintColor(.orange)
        view.setTitleColor(.orange)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(backdropPath: String, rate: String) {
        super.init(frame: .zero)
        setupViews(backdropPath: backdropPath, rate: rate)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews(backdropPath: String, rate: String) {
        backgroundColor = .black
        let fullURL = "https://image.tmdb.org/t/p/w780\(backdropPath)"
        backdropImageView.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: "Background"))
        backdropImageView.layer.cornerRadius = 20
        backdropImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backdropImageView.clipsToBounds = true
        
        ratingLabel.configure(icon: UIImage(named: "Star"), title: rate)
        addSubview(backdropImageView)
        addSubview(paddingView)
        paddingView.addSubview(blurView)
        paddingView.addSubview(ratingLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // backdrop full screen
            backdropImageView.topAnchor.constraint(equalTo: topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backdropImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // ratingLabel in paddingView
            ratingLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 8),
            ratingLabel.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor, constant: -8),
            ratingLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -8),
            
            paddingView.trailingAnchor.constraint(equalTo: backdropImageView.trailingAnchor, constant: -16),
            paddingView.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -12),
            
            // blurView fills paddingView
            blurView.topAnchor.constraint(equalTo: paddingView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor)
        ])
    }
}


class TopAppBarView: UIView {

    let backButton = UIButton()
    let favoriteButton = UIImageView()
    let titleLabel = UILabel()

    var onBackTapped: (() -> Void)?
    
    @objc private func handleBackTapped() {
        onBackTapped?()
    }

    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup
    private func setupViews() {
        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false

        // Back button
        backButton.setImage(UIImage(named: "BackIcon"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        backButton.isUserInteractionEnabled = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)


        // Title
        titleLabel.text = "Detail"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        // Favorite button
        favoriteButton.image = UIImage(named: "FavoriteIcon") // Thay bằng tên ảnh thật
        favoriteButton.contentMode = .scaleAspectFit
        favoriteButton.isUserInteractionEnabled = true
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 32).isActive = true

        // Spacer views để title căn giữa
        

        // Container
        let container = RowView(arrangedSubViews: [
            backButton,
            titleLabel,
            favoriteButton
        ])
        container.setSpacing(by: 12)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alignment = .center

        addSubview(container)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}

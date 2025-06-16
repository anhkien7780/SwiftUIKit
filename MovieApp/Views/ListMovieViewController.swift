//
//  ListMovieViewController.swift
//  MovieApp
//
//  Created by Admin on 6/16/25.
//

import Foundation
import UIKit
import SDWebImage

class ListMovieViewController: UIViewController{
    let screenTitle = UILabel()
    let movieDetailViewModel = MovieDetailViewModel()
    let movieTableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenTitle.text = "Movies"
        screenTitle.textColor = .white
        screenTitle.font = UIFont.boldSystemFont(ofSize: 24)
        screenTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(screenTitle)
        
        view.backgroundColor = .black
        movieDetailViewModel.loadMovieDetail()
        movieTableView.backgroundColor = .black
        _ = movieDetailViewModel.movies
        movieTableView.register(MovieItemCell.self, forCellReuseIdentifier: "MovieItemCell")
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(movieTableView)
        NSLayoutConstraint.activate([
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            movieTableView.topAnchor.constraint(equalTo: screenTitle.safeAreaLayoutGuide.bottomAnchor, constant: 12),
            movieTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            movieTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        movieDetailViewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.movieTableView.reloadData()
            }
        }
        movieDetailViewModel.loadMovieDetail()
    }
}

extension ListMovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieDetailViewModel.movies.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemCell", for: indexPath) as! MovieItemCell
        let movieOptional = movieDetailViewModel.movies[indexPath.row]
        if let movie = movieOptional {
            cell.configure(with: movie)
        }
        return cell
    }

    // Tùy chọn: set height cho mỗi row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 // hoặc UITableView.automaticDimension nếu bạn set layout tốt
    }
}


class MovieItemCell: UITableViewCell{
    let movieItemView = MovieItem()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(movieItemView)
        backgroundColor = .black
        contentView.backgroundColor = .black
        movieItemView.backgroundColor = .black
        movieItemView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieItemView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            movieItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            movieItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            movieItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movieDetail: MovieDetail) {
        movieItemView.setData(
            imageNamed: movieDetail.posterPath ?? "null",
            title: movieDetail.originalTitle,
            averageRate: "\(movieDetail.voteAverage)",
            genre: movieDetail.genres[0].name,
            year: movieDetail.releaseDate,
            runtime: "\(movieDetail.runtime) minutes"
        )
    }
}

class MovieItem: UIView{
    func setData(
        imageNamed: String,
        title: String,
        averageRate: String,
        genre: String,
        year: String,
        runtime: String
    ){
        let viewContainer = UIView()
        viewContainer.backgroundColor = .black
        backgroundColor = .black
        let descriptionIconTextView = ColumnView(
            arrangedSubviews: [
                IconTitleView(imageNamed: "Star", labelTitle: averageRate),
                IconTitleView(imageNamed: "Ticket", labelTitle: genre),
                IconTitleView(imageNamed: "CalendarBlank", labelTitle: year),
                IconTitleView(imageNamed: "Clock", labelTitle: runtime)
            ])
        descriptionIconTextView.setSpacing(by: 6)
        let movieTitle: UILabel = {
            let labelView = UILabel()
            labelView.text = title
            labelView.font = UIFont.systemFont(ofSize: 24)
            labelView.textColor = .white
            
            return labelView
        }()
        

        let fullDescripTion = ColumnView(arrangedSubviews: [movieTitle, descriptionIconTextView])
        fullDescripTion.setSpacing(by: 20)
        
        let posterView = UIImageView()
        
        let fullURL = "https://image.tmdb.org/t/p/w500\(imageNamed)"
        posterView.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: "SpiderMan"))
        
        posterView.clipsToBounds = true
        posterView.layer.cornerRadius = 24
        
        let movieItem = RowView(arrangedSubViews: [posterView, fullDescripTion])
        
        posterView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        fullDescripTion.distribution = .equalSpacing
        
        movieItem.setSpacing(by: 12)
        
        translatesAutoresizingMaskIntoConstraints = false
        descriptionIconTextView.translatesAutoresizingMaskIntoConstraints = false
        fullDescripTion.translatesAutoresizingMaskIntoConstraints = false
        posterView.translatesAutoresizingMaskIntoConstraints = false
        movieItem.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(movieItem)
        
        NSLayoutConstraint.activate([
            movieItem.topAnchor.constraint(equalTo: topAnchor),
            movieItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            movieItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieItem.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
}

class ColumnView: UIStackView {
    init(arrangedSubviews views: [UIView]) {
        super.init(frame: .zero)
        for view in views{
            addArrangedSubview(view)
        }
        setup()
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .black
        axis = .vertical
        distribution = .fill
        alignment = .fill
    }
    
    func setSpacing(by value: CGFloat){
        spacing = value
    }
}

class RowView: UIStackView{
    init(arrangedSubViews views: [UIView]){
        super.init(frame: .zero)
        for view in views{
            addArrangedSubview(view)
        }
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .black
        axis = .horizontal
        distribution = .fill
        alignment = .fill
    }
    
    func setSpacing(by value: CGFloat){
        spacing = value
    }
}

class IconTitleView: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()
    
    init(){
        super.init(frame: .zero)
        setupViews()
    }
    
    init(imageNamed: String, labelTitle: String){
        super.init(frame: .zero)
        setupViews()
        configure(icon: UIImage(named: imageNamed), title: labelTitle)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        backgroundColor = .black
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 24),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor)
        ])
    }
    

    func configure(icon: UIImage?, title: String) {
        iconImageView.image = icon
        titleLabel.text = title
    }
    
    func padding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat){
        layoutMargins = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}

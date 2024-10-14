//
//  MovieDetailViewController.swift
//  MovieDatabase
//
//  Created by Shabuddin SA on 14/10/24.
//

import Foundation
import UIKit
import UIKit

class MovieDetailViewController: UIViewController {
    var movie: Movie?

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let plotLabel = UILabel()
    let releasedLabel = UILabel()
    let genreLabel = UILabel()
//    let ratingControl = RatingControl()
    private let showRatingButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateDetails()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(posterImageView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        plotLabel.numberOfLines = 0
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(plotLabel)

        releasedLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(releasedLabel)

        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genreLabel)

        
        showRatingButton.setTitle("Show Rating", for: .normal)
                showRatingButton.addTarget(self, action: #selector(showRating), for: .touchUpInside)
                showRatingButton.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(showRatingButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height + 100),

            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 200),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            plotLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            plotLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            plotLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            releasedLabel.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 20),
            releasedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            releasedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            genreLabel.topAnchor.constraint(equalTo: releasedLabel.bottomAnchor, constant: 10),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            
            showRatingButton.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 20),
            showRatingButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            showRatingButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func showRating() {
        guard let movie = movie else { return }
        
        let ratingPopup = RatingPopupView(ratings: movie.ratings)
        view.addSubview(ratingPopup)

        // Center the popup view
        NSLayoutConstraint.activate([
            ratingPopup.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ratingPopup.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ratingPopup.widthAnchor.constraint(equalToConstant: 250),
            ratingPopup.heightAnchor.constraint(equalToConstant: 300) // Adjust height if needed
        ])
    }

    
    
    private func populateDetails() {
        guard let movie = movie else { return }
        
        titleLabel.text = movie.title ?? "Unknown Title"
        plotLabel.text = movie.plot ?? "No plot available."
        
        // Load the poster image
        if let posterURLString = movie.poster, let posterURL = URL(string: posterURLString) {
            loadImage(from: posterURL, into: posterImageView)
        } else {
            posterImageView.image = nil // Set to nil if no poster
        }
        
        releasedLabel.text = "Released: \(movie.released ?? "N/A")"
        genreLabel.text = "Genre: \(movie.genre ?? "N/A")"

        // Set the initial rating
//        updateRatingControl(for: movie)
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    imageView.image = nil // Set to nil if failed to load
                }
            }
        }.resume()
    }

//    private func updateRatingControl(for movie: Movie) {
//        // Set the default rating source
//        if let ratings = movie.ratings.first {
//            ratingControl.ratingSource = ratings.source
//            ratingControl.ratingValue = ratings.value
//        }
//    }
}

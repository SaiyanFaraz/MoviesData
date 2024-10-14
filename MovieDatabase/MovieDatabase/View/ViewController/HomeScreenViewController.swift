//
//  ViewController.swift
//  MovieDatabase
//
//  Created by Shabuddin SA on 13/10/24.
//

import UIKit

class HomeScreenViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
        
    private let viewModel = MovieViewModel()
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let dropdownView = DropdownView()
    let secondaryDropdownView = DropdownView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMovies()
        setupDropdownView()
        setupSecondaryDropdownView()
       
    }
    
    func setupUI() {
        // Setup Search Bar
        searchBar.delegate = self
        searchBar.placeholder = "Search by title, actor, director, or genre"
        navigationItem.titleView = searchBar
        
        // Setup Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        view.addSubview(tableView)
//        tableView.frame = view.bounds
        tableView.setAnchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 50, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
    }
    
    func loadMovies() {
        viewModel.loadMovies { [weak self] error in
            if let error = error {
                print("Error loading movies: \(error)")
                return
            }
            self?.tableView.reloadData()
        }
    }
    
    func setupDropdownView() {
        dropdownView.setOptions(["Year", "Genre", "Actor", "Director", "All Movies"])
        dropdownView.selectionHandler = { [weak self] (selectedOption: String) in
            guard let self = self else { return }
            self.dropdownView.isHidden = true
            self.searchBar.resignFirstResponder()

            if selectedOption == "Year" {
                self.showSecondaryDropdown(with: self.getUniqueYears())
            } else if selectedOption == "Genre" {
                self.showSecondaryDropdown(with: self.getUniqueGenres())
            } else if selectedOption == "Actor" {
                self.showSecondaryDropdown(with: self.getUniqueActors())
            } else if selectedOption == "Director" {
                self.showSecondaryDropdown(with: self.getUniqueDirectors())
            } else {
                self.viewModel.filterMoviesByCategory(selectedOption)
                self.tableView.reloadData()
            }
        }
        dropdownView.isHidden = true
        view.addSubview(dropdownView)
        dropdownView.setAnchor(top: self.view.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 70, paddingLeft: 16,  paddingRight: 16, height: 270)
            }

    func setupSecondaryDropdownView() {
        secondaryDropdownView.selectionHandler = { [weak self] (selectedOption: String) in
            self?.searchBar.resignFirstResponder()
            self?.viewModel.filterMoviesByCategory(selectedOption)
            self?.tableView.reloadData()
            self?.secondaryDropdownView.isHidden = true // Hide secondary dropdown
        }
        secondaryDropdownView.isHidden = true
        view.addSubview(secondaryDropdownView)
        secondaryDropdownView.setAnchor(top: self.view.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 70, paddingLeft: 16,  paddingRight: 16, height: 400)
    
    }

    private func showSecondaryDropdown(with options: [String]) {
            secondaryDropdownView.setOptions(options)
            secondaryDropdownView.isHidden = false // Show secondary dropdown
        }

        private func getUniqueYears() -> [String] {
//            let years = viewModel.allMovies.compactMap { $0.year }
////            return years
//            let uniqueYears = Set(years.map { year in
//                    // Extract only the valid year part
//                    let validYear = year.components(separatedBy: "-").first ?? ""
//                    return validYear
//                })
//                
//                return Array(uniqueYears).sorted()
            
            let years = viewModel.allMovies.compactMap { $0.year }
                let uniqueYears = Set(years.map { year in
                    // Remove any trailing non-numeric characters
                    let validYear = year.trimmingCharacters(in: .whitespacesAndNewlines)
                                        .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                    return validYear
                })
                
                return Array(uniqueYears).filter { !$0.isEmpty }.sorted()
        }

        private func getUniqueGenres() -> [String] {
            let genres = viewModel.allMovies.compactMap { $0.genre?.components(separatedBy: ", ") }.flatMap { $0 }.unique()
            return genres
        }

        private func getUniqueActors() -> [String] {
            let actors = viewModel.allMovies.compactMap { $0.actors?.components(separatedBy: ", ") }.flatMap { $0 }.unique()
            return actors
        }

        private func getUniqueDirectors() -> [String] {
            let directors = viewModel.allMovies.compactMap { $0.director }.unique()
            return directors
        }
    
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("viewModel.filteredMovies.count --- \(viewModel.filteredMovies.count)")
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        let movie = viewModel.filteredMovies[indexPath.row]
        cell.textLabel?.text = movie.title ?? "Unknown Title"
        if let posterURLString = movie.poster, let posterURL = URL(string: posterURLString) {
                    loadImage(from: posterURL, into: cell.posterImageView)
                } else {
                    cell.posterImageView.image = nil 
                }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movie = viewModel.filteredMovies[indexPath.row]
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }

    
    private func loadImage(from url: URL, into imageView: UIImageView) {
            // Use URLSession to fetch the image
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
    
    // MARK: - UISearchBarDelegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty ?? true
        {
            dropdownView.isHidden = false
            secondaryDropdownView.isHidden = false

        } else
        {
            dropdownView.isHidden = true
            secondaryDropdownView.isHidden = true
        }
        
        
        viewModel.filterMovies(searchText: searchText)
        tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) 
    {
        if searchBar.text?.isEmpty ?? true
        {
            dropdownView.isHidden = false
        }
    }
    
}



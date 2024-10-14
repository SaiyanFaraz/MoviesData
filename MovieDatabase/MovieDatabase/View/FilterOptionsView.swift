//
//  FilterOptionsView.swift
//  MovieDatabase
//
//  Created by Shabuddin SA on 13/10/24.
//

import Foundation
import UIKit

class FilterOptionsView: UIView, UITableViewDelegate, UITableViewDataSource {
    var options: [String] = []
    var movies: [Movie] = []
    var selectionHandler: ((String) -> Void)?
    
    // Add property to handle nested options
    var nestedOptions: [String] = []
    var isNested: Bool = false

    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func numberOfRowsInSection(section: Int) -> Int {
        return isNested ? nestedOptions.count : options.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isNested ? nestedOptions.count : options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = isNested ? nestedOptions[indexPath.row] : options[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isNested {
            let selectedOption = nestedOptions[indexPath.row]
            selectionHandler?(selectedOption)
            // Optionally, you might want to reset isNested here
            isNested = false
        } else {
            let selectedOption = options[indexPath.row]
            selectionHandler?(selectedOption)
            // Show nested options based on the selected filter
            showNestedOptions(for: selectedOption)
        }
    }

    private func showNestedOptions(for filter: String) {
        switch filter {
        case "Search by Year":
            // Assuming you have a method to fetch unique years
            nestedOptions = fetchUniqueYears()
        case "Search by Genre":
            nestedOptions = fetchUniqueGenres()
        case "Search by Director":
            nestedOptions = fetchUniqueDirectors()
        case "Search by Actor":
            nestedOptions = fetchUniqueActors()
        default:
            break
        }
        isNested = true
        tableView.reloadData()
    }
    
    // Add methods to fetch unique years, genres, directors, and actors
    private func fetchUniqueYears() -> [String] {
        // Implement logic to get unique years from your movies data
        return Array(Set(movies.map { $0.year! })).sorted()
    }
    
    private func fetchUniqueGenres() -> [String] {
        // Implement logic to get unique genres from your movies data
        return Array(Set(movies.flatMap { $0.genre!.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } })).sorted()
    }
    
    private func fetchUniqueDirectors() -> [String] {
        // Implement logic to get unique directors from your movies data
        return Array(Set(movies.map { $0.director! })).sorted()
    }
    
    private func fetchUniqueActors() -> [String] {
        // Implement logic to get unique actors from your movies data
        return Array(Set(movies.flatMap { $0.actors!.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } })).sorted()
    }
}

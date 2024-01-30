//
//  ListVC.swift
//  MovieSearcher
//
//  Created by MacBook on 29.01.2024.
//

import UIKit

final class ListVC: UIViewController {
    //MARK: UI elements
    @IBOutlet private var moviesTableView: UITableView!
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
    }
    //MARK: Private methods
    private func setupDelegates() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? MovieTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
//MARK: - Constatns
extension ListVC {
    enum Constants {
        static let cellIdentifier = "MovieCell"
    }
}

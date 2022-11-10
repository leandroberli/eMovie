//
//  SearchViewController.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import UIKit

protocol SearchViewProtocol {
    var tableView: UITableView! { get set }
    var presenter: SearchPresenterProtocol? { get set }
    func updateViewWithResults(data: [Movie])
}

typealias SearchView = SearchViewProtocol & UIViewController

class SearchViewController: SearchView {
    var presenter: SearchPresenterProtocol?
    
    var tableView: UITableView!
    var searchController: UISearchController!
    var noResultsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateSearchInput()
        generateTableView()
        generateNoResultsLabel()
    }
    
    private func generateNoResultsLabel() {
        noResultsLabel = UILabel()
        noResultsLabel.text = "No results"
        self.view.addSubview(noResultsLabel)
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        noResultsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noResultsLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func generateTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 88).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        
        tableView.register(UINib(nibName: "MovieSearchResultTableCell", bundle: nil), forCellReuseIdentifier: "MovieSearchResultTableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.title = "eMovie"
    }
    
    func generateSearchInput() {
        //NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchTextField.backgroundColor = .systemGray4
        searchController.searchBar.tintColor = .white
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
    }
    
    func updateViewWithResults(data: [Movie]) {
        noResultsLabel.isHidden = !data.isEmpty
        tableView.reloadData()
    }
    
    private func shouldSearchText(_ text: String) {
        presenter?.searchParam(text)
    }
}

//MARK: Search bar
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        if !text.isEmpty {
            print(text)
            shouldSearchText(text)
        } else {
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.presenter?.searchData?.results = []
        self.updateViewWithResults(data: [])
    }
}

//MARK: Tableview
extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.searchData?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = self.presenter?.searchData?.results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSearchResultTableCell", for: indexPath) as! MovieSearchResultTableCell
        cell.setupMovie(movie)
        let providers = self.presenter?.platforms[movie?.original_title ?? ""] as? [ProviderPlataform]
        cell.setupProvidersView(data: providers)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.didTapMovie(index: indexPath.row)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndexs = tableView.indexPathsForVisibleRows ?? []
        
        currentIndexs.forEach({
            let rest = (self.presenter?.searchData?.results.count ?? 0) - $0.row
            if rest < 5 {
                self.presenter?.searchParam(searchController.searchBar.text ?? "" )
            }
        })
    }    
}



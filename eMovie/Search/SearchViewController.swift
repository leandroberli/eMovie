//
//  SearchViewController.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import UIKit

protocol SearchViewProtocol {
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
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white]
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
        
        searchController.searchBar.updateHeight(height: 27.5)
        navigationItem.searchController = searchController
    }
    
    
    func updateViewWithResults(data: [Movie]) {
        noResultsLabel.isHidden = !data.isEmpty
        tableView.reloadData()
    }
    
    private func shouldSearchText(_ text: String) {
        presenter?.searchParam(text)
    }
    
    var lastContentOffeset: CGFloat = 0.0

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
        self.presenter?.searchResults = []
        self.updateViewWithResults(data: [])
    }
}

//MARK: Tableview
extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.searchResults.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = self.presenter?.searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSearchResultTableCell", for: indexPath) as! MovieSearchResultTableCell
        cell.setupMovie(movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.didTapMovie(index: indexPath.row)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //TODO: hide bar when scroll down.
    }
    
}

extension UISearchBar {
    func updateHeight(height: CGFloat, radius: CGFloat = 10) {
        let image: UIImage? = UIImage.imageWithColor(color: UIColor.systemGray4, size: CGSize(width: 1, height: height))
        setSearchFieldBackgroundImage(image, for: .normal)
        for subview in self.subviews {
            for subSubViews in subview.subviews {
                if #available(iOS 13.0, *) {
                    for child in subSubViews.subviews {
                        if let textField = child as? UISearchTextField {
                            textField.layer.cornerRadius = radius
                            textField.clipsToBounds = true
                        }
                    }
                    continue
                }
                if let textField = subSubViews as? UITextField {
                    textField.layer.cornerRadius = radius
                    textField.clipsToBounds = true
                }
            }
        }
    }
}

private extension UIImage {
    static func imageWithColor(color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }
}

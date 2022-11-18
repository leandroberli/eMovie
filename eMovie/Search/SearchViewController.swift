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
    func updateRecentMoviesView()
}

typealias SearchView = SearchViewProtocol & UIViewController

class SearchViewController: SearchView {
    var presenter: SearchPresenterProtocol?
    var tableView: UITableView!
    var collectionView: UICollectionView!
    var searchController: UISearchController!
    var noResultsLabel: UILabel!
    var dataSource: UICollectionViewDiffableDataSource<Section, MovieWrapper>! = nil
    var collectionOriginalContentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateSearchInput()
        generateTableView()
        generateNoResultsLabel()
        generateCollectionView()
    }
    
    private func generateCollectionView() {
        let layout = HomeCollectionBuilder.generateHorizontalSliderLayout()
        collectionView = HomeCollectionBuilder.setupCollection(viewController: self, layout: layout)
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let collectionTopConstraint = collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        collectionTopConstraint.isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        configureDataSource()
        collectionOriginalContentInset = collectionView.contentInset
    }
    
    func configureDataSource() {
        //Setup cells view with the data
        dataSource = UICollectionViewDiffableDataSource<Section, MovieWrapper>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, movie: MovieWrapper) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
                fatalError("Could not create new cell")
            }
            let movie = self.presenter?.recentsMoviesViewed[indexPath.row]
            cell.setupMovie(movie)
            return cell
        }
        
        //For header views
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView else {
                fatalError("Cannot create header view")
            }
            supplementaryView.confiugreSection(.lastViewed)
            return supplementaryView
        }
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, MovieWrapper> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieWrapper>()
        let wrappers = presenter?.recentsMoviesViewed.map({ return MovieWrapper(section: .lastViewed, movie: $0 )}) ?? []
        snapshot.appendSections([Section.lastViewed])
        snapshot.appendItems(wrappers)
        return snapshot
    }
    
    private func generateNoResultsLabel() {
        noResultsLabel = UILabel()
        noResultsLabel.textColor = .systemGray6
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
        setupNav()
        presenter?.getRecentsMoviesViewed()
    }
    
    private func setupNav() {
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.title = "eMovie"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        //appearance.accessibilityPath?.lineWidth = 0
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    func generateSearchInput() {
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
}

//MARK: Protocol functions
extension SearchViewController {
    func updateViewWithResults(data: [Movie]) {
        noResultsLabel.isHidden = !data.isEmpty
        tableView.reloadData()
    }
    
    func updateRecentMoviesView() {
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func shouldSearchText(_ text: String) {
        presenter?.searchParam(text)
    }
}

//MARK: Search bar
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        if !text.isEmpty {
            collectionView.isHidden = true
            print(text)
            shouldSearchText(text)
        } else {
            collectionView.isHidden = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.presenter?.searchData?.results = []
        self.updateViewWithResults(data: [])
        self.collectionView.isHidden = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.collectionView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.collectionView.contentInset = self.collectionOriginalContentInset
        }
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
            if rest < 10 {
                self.presenter?.searchParam(searchController.searchBar.text ?? "" )
            }
        })
    }    
}


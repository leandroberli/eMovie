//
//  HomeViewController.swift
//  eMovie
//
//  Created by Leandro Berli on 26/10/2022.
//

import UIKit
import Kingfisher

protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
    func updateCollectionData()
    func updateTopRatedVisibleCells(index: IndexPath)
}

class HomeViewController: UIViewController, HomeViewProtocol {
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    enum Section: String, CaseIterable {
        case upcoming = "Próximos estrenos"
        case topRated = "Tendencia"
        case recommended = "Recomendados para ti"
    }
    
    var presenter: HomePresenterProtocol?
    var dataSource: UICollectionViewDiffableDataSource<Section, MovieWrapper>! = nil
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        configureDataSource()
        presenter?.getTopRatedMovies()
        presenter?.getUpcomingMovies()
        presenter?.getRecommendedMovies()
    }
    
    func updateTopRatedVisibleCells(index: IndexPath) {
        let item = dataSource.itemIdentifier(for: index)!
        var newSnapshot = dataSource.snapshot()
        newSnapshot.reloadItems([item])
        dataSource.apply(newSnapshot)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.standardAppearance = UINavigationBarAppearance()
        self.navigationController?.navigationBar.standardAppearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance?.configureWithDefaultBackground()
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.title = "eMovie"
    }
    
    private func setupCollection() {
        let layout = HomeCollectionBuilder.generateCombinedLayout()
        collectionView = HomeCollectionBuilder.setupCollection(viewController: self, layout: layout)
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        //Setup cells view with the data
        dataSource = UICollectionViewDiffableDataSource<Section, MovieWrapper>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, movie: MovieWrapper) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
                fatalError("Could not create new cell")
            }
            
            let section = Section.allCases[indexPath.section]
            switch section {
            case .upcoming:
                let wrapper = self.presenter?.upcomingMovies[indexPath.item]
                cell.setupMovie(wrapper?.movie)
                return cell
            case .topRated:
                let wrapper = self.presenter?.topRatedMovies[indexPath.item]
                cell.setupMovie(wrapper?.movie)
                //Using provider data from dict key-value data source.
                let providers = self.presenter?.platformsTopRated[wrapper?.movie.original_title ?? ""] as? [ProviderPlataform]
                cell.setupProvidersView(data: providers)
                return cell
            case .recommended:
                let wrapper = self.presenter?.filtredRecommendedMovies[indexPath.item]
                cell.setupMovie(wrapper?.movie)
                let providers = self.presenter?.platformsRecommended[wrapper?.movie.original_title ?? ""] as? [ProviderPlataform]
                cell.setupProvidersView(data: providers)
                return cell
            }
        }
        
        //For header views
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            //Hide header with filters options.
//            let section = Section.allCases[indexPath.section]
//            if section == .recommended {
//                guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendedHeaderView.reuseIdentifier, for: indexPath) as? RecommendedHeaderView else {
//                    fatalError("Cannot create header view")
//                }
//                //Presenter handles filter buttons logic.
//                supplementaryView.presenter = self.presenter
//                supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
//                return supplementaryView
//            } else {
                guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView else {
                    fatalError("Cannot create header view")
                }
                supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
                return supplementaryView
//            }
        }
    }
    
    //This function trigger configureDataSource function.
    func updateCollectionData() {
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, MovieWrapper> {
        let upcomingMovies = presenter?.upcomingMovies ?? []
        let trendingMoviews = presenter?.topRatedMovies ?? []
        let recommendedMovies = presenter?.filtredRecommendedMovies ?? []
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieWrapper>()
        
        snapshot.appendSections([Section.upcoming])
        snapshot.appendItems(upcomingMovies)
        
        snapshot.appendSections([Section.topRated])
        snapshot.appendItems(trendingMoviews)
        
        snapshot.appendSections([Section.recommended])
        snapshot.appendItems(recommendedMovies)
        
        return snapshot
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section.allCases[indexPath.section]
        let index = indexPath.item
        self.presenter?.navigateToMovieDetail(movieIndex: index, fromSection: section)
    }
}

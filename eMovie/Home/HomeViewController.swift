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
}

class HomeViewController: UIViewController, HomeViewProtocol {
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    enum Section: String, CaseIterable {
        case upcoming = "Próximos estrenos"
        case topRated = "Tendencia"
        case recommended = "Recomendados para ti"
    }
    
    var presenter: HomePresenterProtocol?
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>! = nil
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "eMovie"
        
        setupCollection()
        configureDataSource()
        presenter?.getTopRatedMovies()
        presenter?.getUpcomingMovies()
    }
    
    private func setupCollection() {
        let layout = generateLayout()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: HomeViewController.sectionHeaderElementKind,
          withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(RecommendedHeaderView.self, forSupplementaryViewOfKind: HomeViewController.sectionHeaderElementKind,
          withReuseIdentifier: RecommendedHeaderView.reuseIdentifier)
    }
    
    func configureDataSource() {
        //Setup cells view with the data
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, movie: Movie) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
                fatalError("Could not create new cell")
            }
            
            let section = Section.allCases[indexPath.section]
            switch section {
            case .upcoming:
                let movie = self.presenter?.upcomingMovies[indexPath.item]
                cell.setupMovie(movie)
                return cell
            case .topRated:
                let movie = self.presenter?.topRatedMovies[indexPath.item]
                cell.setupMovie(movie)
                return cell
            case .recommended:
                let movie = self.presenter?.recommendedMovies[indexPath.item]
                cell.setupMovie(movie)
                return cell
            }
        }
        
        //For header views
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let section = Section.allCases[indexPath.section]
            
            if section == .recommended {
                guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendedHeaderView.reuseIdentifier, for: indexPath) as? RecommendedHeaderView else {
                    fatalError("Cannot create header view")
                }
                supplementaryView.presenter = self.presenter
                supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
                return supplementaryView
            } else {
                guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView else {
                    fatalError("Cannot create header view")
                }
                supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
                return supplementaryView
            }
        }
    }
    
    //This function trigger configureDataSource function.
    func updateCollectionData() {
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Movie> {
        let upcomingMovies = presenter?.upcomingMovies ?? []
        let trendingMoviews = presenter?.topRatedMovies ?? []
        let recommendedMovies = presenter?.recommendedMovies ?? []
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        
        snapshot.appendSections([Section.upcoming])
        snapshot.appendItems(upcomingMovies)
        
        snapshot.appendSections([Section.topRated])
        snapshot.appendItems(trendingMoviews)
        
        snapshot.appendSections([Section.recommended])
        snapshot.appendItems(recommendedMovies)
        
        return snapshot
    }
    
    //For upcoming and top rated movies layout.
    func generateHorizontalSliderLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(138), heightDimension: .estimated(181))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: fullPhotoItem, count: 1)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)

        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    func generateReccomendedLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 7.5, bottom: 12, trailing: 7.5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [fullPhotoItem])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .upcoming:
                return self.generateHorizontalSliderLayout()
            case .topRated:
                return self.generateHorizontalSliderLayout()
            case .recommended:
                return self.generateReccomendedLayout()
            }
        }
        return layout
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section.allCases[indexPath.section]
        let index = indexPath.item
        self.presenter?.navigateToMovieDetail(movieIndex: index, fromSection: section)
    }
}

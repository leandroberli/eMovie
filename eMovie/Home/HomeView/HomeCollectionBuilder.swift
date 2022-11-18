//
//  HomeCollectionBuilder.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation
import UIKit

enum Section: Int, CaseIterable {
    case upcoming = 0
    case topRated = 1
    case recommended = 2
    case favorites = 3
    case lastViewed = 4
    
    var title: String {
        switch self {
        case .topRated:
            return "Top rated"
        case .recommended:
            return "Recommended for you!"
        case .upcoming:
            return "Upcoming"
        case .favorites:
            return "Favorites"
        case .lastViewed:
            return "Last visited"
        }
    }
}

class HomeCollectionBuilder {
    
    /// Setup collection configuration into view controller with specified layout
    /// - Parameters:
    ///   - viewController: view controller wich will contains collection
    ///   - layout: collection view layout
    /// - Returns: collection view object
    static func setupCollection(viewController: UIViewController, layout: UICollectionViewLayout) -> UICollectionView {
        let collectionView = UICollectionView(frame: viewController.view.bounds, collectionViewLayout: layout)
        viewController.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.register(UINib(nibName: "RecommendedMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendedMovieCollectionViewCell")
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: HomeViewController.sectionHeaderElementKind,
          withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(RecommendedHeaderView.self, forSupplementaryViewOfKind: HomeViewController.sectionHeaderElementKind,
          withReuseIdentifier: RecommendedHeaderView.reuseIdentifier)
        return collectionView
    }
    
    /// Generate two columns layout
    /// - Returns: layout
    static func generateRecommendedLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self.generateReccomendedLayoutSection()
        }
        return layout
    }
    
    private static func generateReccomendedLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [fullPhotoItem])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    /// Generate horizontal slider layout. (For upcoming and top rated movies layout)
    /// - Returns: layout
    static func generateHorizontalSliderLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self.generateHorizontalSliderLayoutSection()
        }
        return layout
    }
    
    private static func generateHorizontalSliderLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(138), heightDimension: .estimated(181))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: fullPhotoItem, count: 1)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    /// Generates collection layout like Home collection
    /// - Returns: Layout
    static func generateCombinedLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .upcoming:
                return self.generateHorizontalSliderLayoutSection()
            case .topRated:
                return self.generateHorizontalSliderLayoutSection()
            case .recommended:
                return self.generateReccomendedLayoutSection()
            default:
                return self.generateHorizontalSliderLayoutSection()
            }
        }
        return layout
    }
}

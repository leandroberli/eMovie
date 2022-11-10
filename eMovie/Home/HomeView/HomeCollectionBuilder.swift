//
//  HomeCollectionBuilder.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation
import UIKit

class HomeCollectionBuilder {
    
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
    
    static func generateRecommendedLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self.generateReccomendedLayoutSection()
        }
        return layout
    }
    
    static func generateReccomendedLayoutSection() -> NSCollectionLayoutSection {
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
    
    //For upcoming and top rated movies layout.
    static func generateHorizontalSliderLayoutSection() -> NSCollectionLayoutSection {
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
    
    static func generateCombinedLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section = HomeViewController.Section.allCases[sectionIndex]
            switch section {
            case .upcoming:
                return self.generateHorizontalSliderLayoutSection()
            case .topRated:
                return self.generateHorizontalSliderLayoutSection()
            case .recommended:
                return self.generateReccomendedLayoutSection()
            }
        }
        return layout
    }
}

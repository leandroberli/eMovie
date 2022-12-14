//
//  ProfileViewController.swift
//  eMovie
//
//  Created by Leandro Berli on 03/11/2022.
//

import UIKit
import WebKit

protocol ProfileViewProtocol {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func updateAccountDetail(withData: Account?)
    func updateFavoriteMovies(data: [MovieWrapper])
    func updateCellsForProvidersData(data: Any?)
}

class ProfileViewController: UIViewController, ProfileViewProtocol {
    func updateCellsForProvidersData(data: Any?) {
        let visibleIndexes = collectionView.indexPathsForVisibleItems
        var newSnapshot = dataSource.snapshot()
        var itemsToReload: [MovieWrapper] = []
        for index in visibleIndexes {
            let dataItem = dataSource.itemIdentifier(for: index)!
            itemsToReload.append(dataItem)
        }
        newSnapshot.reloadItems(itemsToReload)
        dataSource.apply(newSnapshot)
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var presenter: ProfilePresenterProtocol?
    var dataSource: UICollectionViewDiffableDataSource<HomeViewController.Section, MovieWrapper>! = nil
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateLogoutButton()
        presenter?.getAccountDetails()
        
        let layout = HomeCollectionBuilder.generateRecommendedLayout()
        collectionView = HomeCollectionBuilder.setupCollection(viewController: self, layout: layout)
        collectionView.delegate = self
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.getFavoriteMovies()
        configNavbar()
    }
    
    private func configNavbar() {
        let appearance = UINavigationBarAppearance()
        appearance.accessibilityPath?.lineWidth = 0
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        appearance.setBackIndicatorImage(UIImage(systemName: "arrow.left"), transitionMaskImage: UIImage(systemName: "arrow.left"))
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationItem.backButtonTitle = ""
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeViewController.Section, MovieWrapper>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, movie: MovieWrapper) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
                fatalError("Could not create new cell")
            }
            cell.setupMovie(movie.movie)
            let providers = self.presenter?.providers?[movie.movie.original_title ?? ""] as? [ProviderPlataform]
            cell.setupProvidersView(data: providers)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView else {
                fatalError("Cannot create header view")
            }
            supplementaryView.label.text = "Favoritos"
            supplementaryView.imageView.image = UIImage(systemName: "heart.fill")
            return supplementaryView
        }
    }
    
    func snapshotForCurrentState(data: [MovieWrapper]) -> NSDiffableDataSourceSnapshot<HomeViewController.Section, MovieWrapper> {
        var snapshot = NSDiffableDataSourceSnapshot<HomeViewController.Section, MovieWrapper>()
        snapshot.appendSections([HomeViewController.Section.upcoming])
        snapshot.appendItems(data)
        return snapshot
    }
    
    func updateFavoriteMovies(data: [MovieWrapper]) {
        let snapshot = snapshotForCurrentState(data: data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func updateAccountDetail(withData: Account?) {
        navigationItem.title = withData?.username ?? ""
    }
    
    private func generateLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logoutAction))
    }
    
    @objc func logoutAction(_ sender: Any) {
        presenter?.didTapLogoutButton()
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter?.didTapFavoriteItem(at: indexPath.row)
    }
}



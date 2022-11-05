//
//  HomeRouter.swift
//  eMovie
//
//  Created by Leandro Berli on 01/11/2022.
//

import Foundation
import UIKit

protocol HomeRouterProtocol {
    static func createHomeModule() -> UIViewController
    func navigateMovieDetailScreen(from view: UIViewController, andMovie: Movie)
}

class HomeRouter: HomeRouterProtocol {
    
    class func createHomeModule() -> UIViewController {
        let normalFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        let selectedFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let selectedColor = UIColor.white
        let normalColor = UIColor.systemGray
        
        let titleNormalAttr = [NSAttributedString.Key.font: normalFont, NSAttributedString.Key.foregroundColor: normalColor]
        let titleSelectedAttr = [NSAttributedString.Key.font: selectedFont, NSAttributedString.Key.foregroundColor: selectedColor]
        
        //Home controller
        let homeController = HomeViewController()
        let item = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        //item.setTitleTextAttributes(titleNormalAttr, for: .normal)
        homeController.tabBarItem = item
        
        let interactor: HomeInteractorProtocol = HomeInteractor()
        let router: HomeRouterProtocol = HomeRouter()
        let presenter = HomePresenter(view: homeController, interactor: interactor, router: router)
        
        homeController.presenter = presenter
        
        //Map controller
        let mapsController = MapViewController()
        let item2 = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        item2.badgeValue = "New"
        mapsController.tabBarItem = item2
        
        
        //Profile tab
        let loginController = LoginRouter.createLoginModule() 
        let item3 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        loginController.tabBarItem = item3

        
        //Tabbar controller. Root of main navigation controller.
        let style = UITabBarAppearance()
        style.stackedLayoutAppearance.normal.titleTextAttributes = titleNormalAttr
        style.stackedLayoutAppearance.normal.iconColor = normalColor
        
        style.stackedLayoutAppearance.selected.titleTextAttributes = titleSelectedAttr
        style.stackedLayoutAppearance.selected.iconColor = selectedColor
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.standardAppearance = style
        tabBarController.viewControllers = [homeController, mapsController, loginController]
        tabBarController.navigationItem.title = "eMovie"
        tabBarController.navigationItem.backButtonTitle = ""
        
        //Navigation controller. The toppest controller in the hirearchy.
        let navController = UINavigationController(rootViewController: tabBarController)
        
        return navController
    }
    
    func navigateMovieDetailScreen(from view: UIViewController, andMovie: Movie) {
        let detailModule = MovieDetailRouter.createMovieDetailModule(forMovie: andMovie)
        view.navigationController?.pushViewController(detailModule, animated: true)
    }
}

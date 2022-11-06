//
//  TabBarRouter.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation
import UIKit

protocol TabBarRouterProtocol {
    static func createTabBarModule() -> UIViewController
}

class TabBarRouter: TabBarRouterProtocol {
    
    static func createTabBarModule() -> UIViewController {
        let tabBarController = TabBarController()
        
        let homeModule = HomeRouter.createHomeModule()
        tabBarController.viewControllers = [homeModule]
        
        let searchController = SearchRouter.createSearchModule()
        tabBarController.viewControllers?.append(searchController)
        
        if let _ = UserDefaults.standard.value(forKey: "sessionToken") {
            let profileModule = ProfileRouter.createProfileModule()
            tabBarController.viewControllers?.append(profileModule)
        } else {
            let loginModule = LoginRouter.createLoginModule()
            tabBarController.viewControllers?.append(loginModule)
        }
        
        let navController = tabBarController
        return navController
    }
}

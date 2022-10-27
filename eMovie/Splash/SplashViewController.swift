//
//  SplashViewController.swift
//  eMovie
//
//  Created by Leandro Berli on 26/10/2022.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = HomeViewController()
        let presenter = HomePresenter(view: home, httpClient: HTTPClient())
        home.presenter = presenter
        self.navigationController?.pushViewController(home, animated: true)

    }

}

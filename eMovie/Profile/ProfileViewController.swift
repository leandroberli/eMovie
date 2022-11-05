//
//  ProfileViewController.swift
//  eMovie
//
//  Created by Leandro Berli on 03/11/2022.
//

import UIKit
import WebKit

class ProfileViewController: UIViewController {
    
    let loginUrl = "https://www.themoviedb.org/authenticate/{REQUEST_TOKEN}?redirect_to=http://emovie"
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}



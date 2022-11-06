//
//  File.swift
//  eMovie
//
//  Created by Leandro Berli on 05/11/2022.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    let normalFont = UIFont.systemFont(ofSize: 10, weight: .regular)
    let selectedFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
    let normalColor = UIColor.systemGray
    let selectedColor = UIColor.systemBlue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleNormalAttr = [NSAttributedString.Key.font: normalFont, NSAttributedString.Key.foregroundColor: normalColor]
        let titleSelectedAttr = [NSAttributedString.Key.font: selectedFont, NSAttributedString.Key.foregroundColor: selectedColor]
        
        let style = UITabBarAppearance()
        style.stackedLayoutAppearance.normal.titleTextAttributes = titleNormalAttr
        style.stackedLayoutAppearance.normal.iconColor = normalColor
        
        style.stackedLayoutAppearance.selected.titleTextAttributes = titleSelectedAttr
        style.stackedLayoutAppearance.selected.iconColor = selectedColor
        
        self.tabBar.standardAppearance = style
        self.tabBar.scrollEdgeAppearance = style
    }
}

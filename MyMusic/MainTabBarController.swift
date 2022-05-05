//
//  MainTabBarController.swift
//  MyMusic
//
//  Created by Дарья Носова on 03.05.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .gray
        
        let searchVC = SearchViewController()
        
        let libraryVC = ViewController()
        
        
        viewControllers = [
            searchVC,
            libraryVC
        ]
    }
    
}

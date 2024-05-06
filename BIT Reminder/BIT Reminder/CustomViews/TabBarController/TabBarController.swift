//
//  TabBarController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 13.9.23..
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    var viewControllersList: [UIViewController] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.configureControllers()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        self.tabBar.isHidden = false
        self.tabBar.backgroundColor = .clear
        self.tabBar.barTintColor = .clear
        self.tabBar.tintColor = .white
        let height = UIScreen.main.bounds.height
        let layer = CAShapeLayer()
        
        if height > 736 {
            layer.path = UIBezierPath(roundedRect: CGRect(x: 10, y: self.tabBar.bounds.minY, width: self.tabBar.bounds.width - 20, height:
            self.tabBar.bounds.height + 10), cornerRadius: (self.tabBar.frame.width/2)).cgPath
        } else {
            layer.path = UIBezierPath(roundedRect: CGRect(x: 10, y: self.tabBar.bounds.minY, width: self.tabBar.bounds.width - 20, height:
            self.tabBar.bounds.height + 10), cornerRadius: (0)).cgPath
        }
        
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 25.0
        layer.shadowOpacity = 0.3
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = Asset.textfieldBlueColor.color.cgColor
        
        self.tabBar.layer.insertSublayer(layer, at: 0)
        
        if let items = self.tabBar.items {
          items.forEach { item in item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0) }
        }
        
        self.tabBar.itemWidth = 45.0
        self.tabBar.itemPositioning = .centered
    }
    
    private func configureControllers() {

        let homeTabBarVC = setHomeTabBarController()
        viewControllersList.append(UINavigationController(rootViewController: homeTabBarVC))

        let mapTabBarVC = setMapTabBarController()
//        viewControllersList.append(UINavigationController(rootViewController: mapTabBarVC))
        viewControllersList.append(mapTabBarVC)

        let albumTabBarVC = setAlbumTabBarController()
        viewControllersList.append(UINavigationController(rootViewController: albumTabBarVC))

        let settingsTabBarVC = setSettingsTabBarController()
        viewControllersList.append(UINavigationController(rootViewController: settingsTabBarVC))

        viewControllers = viewControllersList
    }

    private func setHomeTabBarController() -> HomeViewController {
        let viewController = StoryboardScene.Authentification.homeViewController.instantiate()
        viewController.presenter = HomeViewPresenter()
        viewController.presenter.screenName = L10n.titleLabelHome
        viewController.tabBarItem = UITabBarItem.init(title: L10n.titleLabelHome,
                                              image: UIImage(systemName: "house"),
                                              selectedImage: UIImage(systemName: "house.fill"))
        return viewController
    }

    private func setMapTabBarController() -> MapViewController {
        let viewController = StoryboardScene.Authentification.mapViewController.instantiate()
        viewController.presenter = MapViewPresenter()
        viewController.tabBarItem = UITabBarItem.init(title: L10n.titleLabelMap,
                                              image: UIImage(systemName: "map"),
                                              selectedImage: UIImage(systemName: "map.fill"))
        return viewController
    }

    private func setAlbumTabBarController() -> AlbumsViewController {
        let viewController = StoryboardScene.Authentification.albumsViewController.instantiate()
        viewController.presenter = AlbumsViewPresenter()
        viewController.tabBarItem = UITabBarItem.init(title: L10n.titleLabelAlbum,
                                                      image: UIImage(systemName: "photo.on.rectangle"),
                                                      selectedImage: UIImage(systemName: "photo.fill.on.rectangle.fill"))
        return viewController
    }

    private func setSettingsTabBarController() -> SettingsViewController {
        let viewController = StoryboardScene.Authentification.settingsViewController.instantiate()
        viewController.presenter = SettingsViewPresenter()
        viewController.tabBarItem = UITabBarItem.init(title: L10n.titleLabelSettings,
                                                      image: UIImage(systemName: "gearshape"),
                                                      selectedImage: UIImage(systemName: "gearshape.fill"))
        return viewController
    }
}

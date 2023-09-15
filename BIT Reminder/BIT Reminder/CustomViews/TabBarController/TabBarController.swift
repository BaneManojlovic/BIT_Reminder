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
        self.tabBar.backgroundColor = Asset.textfieldBlueColor.color
        self.tabBar.barTintColor = Asset.textfieldBlueColor.color
        self.tabBar.tintColor = .white
    }

    private func configureControllers() {

        let homeTabBarVC = setHomeTabBarController()
        viewControllersList.append(UINavigationController(rootViewController: homeTabBarVC))

        let mapTabBarVC = setMapTabBarController()
        viewControllersList.append(UINavigationController(rootViewController: mapTabBarVC))

        let albumTabBarVC = setAlbumTabBarController()
        viewControllersList.append(UINavigationController(rootViewController: albumTabBarVC))

        let settingsTabBarVC = setSettingsTabBarController()
        viewControllersList.append(UINavigationController(rootViewController: settingsTabBarVC))

        viewControllers = viewControllersList
    }

    // TODO: - Rename this VC maybe?!
    private func setHomeTabBarController() -> HomeViewController {
        let viewController = StoryboardScene.Authentification.homeViewController.instantiate()
        viewController.presenter = HomeViewPresenter()
        viewController.presenter.screenName = "Home"
        viewController.tabBarItem = UITabBarItem.init(title: "Home",
                                              image: UIImage(systemName: "house"),
                                              selectedImage: UIImage(systemName: "house.fill"))
        return viewController
    }

    private func setMapTabBarController() -> MapViewController {
        let viewController = StoryboardScene.Authentification.mapViewController.instantiate()
        viewController.presenter = MapViewPresenter()
        viewController.tabBarItem = UITabBarItem.init(title: "Map",
                                              image: UIImage(systemName: "map"),
                                              selectedImage: UIImage(systemName: "map.fill"))
        return viewController
    }

    private func setAlbumTabBarController() -> AlbumsViewController {
        let viewController = StoryboardScene.Authentification.albumsViewController.instantiate()
        viewController.presenter = AlbumsViewPresenter()
        viewController.tabBarItem = UITabBarItem.init(title: "Album",
                                                      image: UIImage(systemName: "photo.on.rectangle"),
                                                      selectedImage: UIImage(systemName: "photo.fill.on.rectangle.fill"))
        return viewController
    }

    private func setSettingsTabBarController() -> SettingsViewController {
        let viewController = StoryboardScene.Authentification.settingsViewController.instantiate()
        viewController.presenter = SettingsViewPresenter()
        viewController.tabBarItem = UITabBarItem.init(title: "Settings",
                                                      image: UIImage(systemName: "gearshape"),
                                                      selectedImage: UIImage(systemName: "gearshape.fill"))
        return viewController
    }
}

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
        let homeVC = StoryboardScene.Authentification.homeViewController.instantiate()
        homeVC.presenter = HomeViewPresenter()
        homeVC.presenter.screenName = "Home"
        homeVC.tabBarItem = UITabBarItem.init(title: "",
                                              image: UIImage(systemName: "house"),
                                              selectedImage: UIImage(systemName: "house.fill"))
        return homeVC
    }

    private func setMapTabBarController() -> HomeViewController {
        let homeVC = StoryboardScene.Authentification.homeViewController.instantiate()
        homeVC.presenter = HomeViewPresenter()
        homeVC.presenter.screenName = "Map"
        homeVC.tabBarItem = UITabBarItem.init(title: "",
                                              image: UIImage(systemName: "map"),
                                              selectedImage: UIImage(systemName: "map.fill"))
        return homeVC
    }

    private func setAlbumTabBarController() -> HomeViewController {
        let homeVC = StoryboardScene.Authentification.homeViewController.instantiate()
        homeVC.presenter = HomeViewPresenter()
        homeVC.presenter.screenName = "Album"
        homeVC.tabBarItem = UITabBarItem.init(title: "",
                                              image: UIImage(systemName: "photo.on.rectangle"),
                                              selectedImage: UIImage(systemName: "photo.fill.on.rectangle.fill"))
        return homeVC
    }

    private func setSettingsTabBarController() -> HomeViewController {
        let homeVC = StoryboardScene.Authentification.homeViewController.instantiate()
        homeVC.presenter = HomeViewPresenter()
        homeVC.presenter.screenName = "Settings"
        homeVC.tabBarItem = UITabBarItem.init(title: "",
                                              image: UIImage(systemName: "gearshape"),
                                              selectedImage: UIImage(systemName: "gearshape.fill"))
        return homeVC
    }
}

//
//  BaseNavigationController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 11.9.23..
//

import UIKit

/*
    Note:
 
    This Controller is inteded tu be
    basic ViewController for setup of any
    in deepth Navigation througth screens.
 
    This ViewController should be inherited
    from any other Navigation View controller
    that we are building in the future.
 
    It has custom navigation bar buttons,
    images, titles to be used or not.
 */

class BaseNavigationController: BaseViewController {

    // MARK: - Properties

    var haveBackButton: Bool = false {
        didSet {
            if haveBackButton {
                self.setBackButton()
            } else {
                self.hideBackButton()
            }
        }
    }

    var haveNextButton: Bool = false {
        didSet {
            if haveNextButton {
                self.setNextButton()
            } else {
                self.hideNextButton()
            }
        }
    }

    var haveAddButton: Bool = false {
        didSet {
            if haveAddButton {
                self.setAddButton()
            } else {
                self.hideAddButton()
            }
        }
    }

    lazy var customNavBarImage: UIImageView = {
       var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = nil
        return image
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = Asset.backgroundBlueColor.color
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    // MARK: - Private Setup Methods
    /// setup for Back button if needed
    private func setBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backArrowAction))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }

    private func hideBackButton() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
    }
    /// setup for Next button if needed
    private func setNextButton() {
        let nextButton = UIBarButtonItem(image: UIImage(systemName: "arrow.right"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(nextArrowAction))
        nextButton.tintColor = .white
        navigationItem.rightBarButtonItem = nextButton
    }

    private func hideNextButton() {
        navigationItem.rightBarButtonItem = nil
    }

    /// setup for Add button if needed
    private func setAddButton() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(addButtonAction))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }

    private func hideAddButton() {
        navigationItem.rightBarButtonItem = nil
    }

    func setupNavigationBarWithImage(image: UIImage) {
        /// fill data for image
        self.customNavBarImage.image = image
        /// setup constrains for image view position and size
        self.view.addSubview(self.customNavBarImage)
        NSLayoutConstraint.activate([
            self.customNavBarImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.customNavBarImage.widthAnchor.constraint(equalToConstant: 40),
            self.customNavBarImage.heightAnchor.constraint(equalToConstant: 40),
            self.customNavBarImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        ])
        /// add custom image view ass UIBarButtonItem
        let leftItemImage = UIBarButtonItem(customView: self.customNavBarImage)
        self.navigationItem.leftBarButtonItems?.append(leftItemImage)
    }

    // MARK: - Action Methods

    @objc func backArrowAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func nextArrowAction() {
        // Override in ViewController that inherits BaseNavigationControllert if needed
        /*
         Example:
            
         override func nextArrowAction() {
             super.nextArrowAction()
             debugPrint("overriden ... do something")
         }
         */
    }

    @objc func addButtonAction() {
        // Override in ViewController that inherits BaseNavigationControllert if needed
        /*
         Example:
            
         override func addButtonAction() {
             super.addButtonAction()
             debugPrint("overriden ... do something")
         }
         */
    }
}

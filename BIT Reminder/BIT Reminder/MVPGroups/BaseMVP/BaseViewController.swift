//
//  BaseViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 6.9.23..
//

import UIKit

/*
    Note:
 
    This Controller is inteded tu be
    basic ViewController for setup of any
    other View Controller.
 
    This ViewController contains methods
    for Error handling therefore should be
    inherited from any other ViewController
 */


class BaseViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // TODO:- Write API Error handling methods
}

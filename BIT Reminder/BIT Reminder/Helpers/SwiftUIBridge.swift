//
//  SwiftUIBridge.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.5.24..
//

import Foundation
import SwiftUI

class SwiftUIBridge: NSObject {
    
    
    @objc static func openProfileScreen(navigationController: UINavigationController) -> UIViewController {
        return CustomHostingController(rootView: ProfileView(navigationController: navigationController), previousViewController: nil)
    }
}

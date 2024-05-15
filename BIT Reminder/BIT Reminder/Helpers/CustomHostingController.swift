//
//  CustomHostingController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.5.24..
//

import Foundation
import SwiftUI


class CustomHostingController <Content>: UIHostingController<AnyView> where Content : View {
    private weak var previousViewController: UIViewController?
    private var shouldShowNavigationBar: Bool
    private let shouldShowNavigationBarAfterBack: Bool
    
    public init( rootView: Content, previousViewController: UIViewController?,
                 shouldShowNavigationBar: Bool = false, shouldShowNavigationBarAfterBack: Bool = true) {
        
        self.previousViewController = previousViewController
        self.shouldShowNavigationBar = shouldShowNavigationBar
        self.shouldShowNavigationBarAfterBack = shouldShowNavigationBarAfterBack

        super.init(rootView: AnyView(rootView))
    }
    
    public init(coder: NSCoder, rootView: Content, previousViewController: UIViewController?,
                shouldShowNavigationBar: Bool = false, shouldShowNavigationBarAfterBack: Bool = true) {
        
        self.previousViewController = previousViewController
        self.shouldShowNavigationBar = shouldShowNavigationBar
        self.shouldShowNavigationBarAfterBack = shouldShowNavigationBarAfterBack
        
        super.init(coder: coder,rootView: AnyView(rootView))!
    }
    
    override func viewDidLayoutSubviews() {
        navigationController?.setNavigationBarHidden(!shouldShowNavigationBar, animated: false)
        super.viewDidLayoutSubviews()
        self.view.invalidateIntrinsicContentSize()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf
                .previousViewController?
                .navigationController?
                .setNavigationBarHidden(!strongSelf.shouldShowNavigationBarAfterBack, animated: false)
        }
    }
    
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

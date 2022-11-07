//
//  ModuleInterfaceRouter.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

class ModuleInterfaceRouter {
    
    // MARK: - Models
    
    enum Task {
        case push(view: UIViewController)
        case pop
    }
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Init
    
    init() {
        self.navigationController = UINavigationController()
    }

    // MARK: - Methods
    
    func add(to window: UIWindow, startingModule: Module, view: CalculatorViewController) {
        self.navigationController.pushViewController(view, animated: true)
        self.navigationController = UINavigationController(rootViewController: view)
        window.rootViewController = self.navigationController
        window.makeKeyAndVisible()
    }
    
    func process(task: Task) {
        switch task {
        case .push(let view):
            self.navigationController.pushViewController(view, animated: true)
        case .pop:
            self.navigationController.popViewController(animated: true)
        }
    }
}

//
//  ModuleInterfaceInteractor.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import Foundation

class ModuleInterfaceInteractor {
    
    // MARK: - Models
    
    enum Task {
        case registerTransformers
    }
    
    // MARK: - Properties
    
    let dataManager: DataManager
    
    // MARK:  - Init
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    // MARK: - Methods
    
    func process(task: Task) {
        switch task {
        case .registerTransformers:
            CalculatorTransformer.register()
        }
    }
}

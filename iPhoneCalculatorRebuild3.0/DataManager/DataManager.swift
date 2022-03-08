//
//  DataManager.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/1/22.
//

import Foundation

class DataManager {
    
    // MARK: - Models
    
    private struct Local {
        let calculator = CoreData()
    }
    
    // MARK: - Properties
    
    private let local: Local = Local()
}

// MARK: - Calculator Module

extension DataManager: DataManagerToCalculatorInteractorProtocol {
    func fetch() -> CalculatorPersistedData {
        let entity: CalculatorCoreDataEntity = self.local.calculator.fetch()
        
        guard let persistedDataModel = entity.model else { fatalError() }
        return persistedDataModel
    }
    
    func persist(data: CalculatorPersistedData) {
        self.local.calculator.persist(dataModel: data)
    }
}

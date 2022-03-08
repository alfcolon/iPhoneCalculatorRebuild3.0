//
//  DataManagerProtocols.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/1/22.
//

import Foundation

protocol DataManagerToCalculatorInteractorProtocol {
    func fetch() -> CalculatorPersistedData
    func persist(data: CalculatorPersistedData)
}

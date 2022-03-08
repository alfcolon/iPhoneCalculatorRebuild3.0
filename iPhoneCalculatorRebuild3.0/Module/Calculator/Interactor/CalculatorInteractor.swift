//
//  CalculatorInteractor.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

class CalculatorInteractor {

    // MARK: - Properties
    
    var calculator: Calculator!
    var persistedCalculatorData: CalculatorPersistedData!
    var dataManager: DataManager
    var presenter: CalculatorPresenterToCalculatorInteractorProtocol
    
    // MARK: - Init
    
    init(dataManager: DataManager, presenter: CalculatorPresenterToCalculatorInteractorProtocol) {
        self.dataManager = dataManager
        self.presenter = presenter
    }
}

extension CalculatorInteractor: CalculatorInteractorToCalculatorModulePresenterProtocol {
    enum Update {
        case calculator(viewSize: CGSize)
        case persistedData(PersistedData)
        
        enum PersistedData {
            case copiedNumber
            case pasteNumber
            case load
            case reload
            case selectedCalculatorFuncion(CalculatorFunction)
            case userSwipedLeft(onNumber: Bool)
        }
    }
    
    func process(update: CalculatorInteractor.Update) {
        switch update {
        case .calculator(let viewSize):
            self.calculator = viewSize.width > viewSize.height ? .scientific : .standard
            self.presenter.respond(to: .active(self.calculator))
        case .persistedData(let update):
            switch update {
            case .copiedNumber:
                // * if the term changes, so does the copied term, use a copy
                let copiedDisplayNumber: TermProtocol = {
                    let displayNumber = self.persistedCalculatorData.display.displayNumber
                    switch displayNumber.termType {
                    case .mutableNumber:
                        let mutableDisplayNumber = displayNumber as! MutableNumber
                        let mutableNumber = MutableNumber(shouldToggleNumberSign: mutableDisplayNumber.negateNumber)
                        mutableNumber.decimalAdded = mutableDisplayNumber.decimalAdded
                        mutableNumber.fractionArray = mutableDisplayNumber.fractionArray
                        mutableNumber.integerArray = mutableDisplayNumber.integerArray
                        
                        return mutableNumber as TermProtocol
                    default:
                        let doubleNumber: DoubleNumber = .init(doubleValue: displayNumber.doubleValue)
                        return doubleNumber as TermProtocol
                    }
                }()

                self.presenter.respond(to: .calculatorDisplay(.pastedNumber(self.persistedCalculatorData.display.copiedNumber!)))
            case .load:
                self.calculator = UIScreen.main.fixedCoordinateSpace.bounds.size.width > UIScreen.main.fixedCoordinateSpace.bounds.size.width ? .scientific : .standard
                self.persistedCalculatorData = self.dataManager.fetch()
                
                self.presenter.respond(to: .active(self.calculator))
                self.presenter.respond(to: .calculatorDisplay(.displayNumber(self.persistedCalculatorData.display.displayNumber)))
                self.presenter.respond(to: .calculatorKeyboard(.clearFunction(self.persistedCalculatorData.functions.displayedClearFunction)))
                self.presenter.respond(to: .calculatorKeyboard(.clearFunction(self.persistedCalculatorData.functions.displayedSIUnit)))
                self.presenter.respond(to: .calculatorKeyboard(.show2ndFunctions(self.persistedCalculatorData.functions.show2ndFunctions)))
                
                if let selectedCalculatorFunction = self.persistedCalculatorData.functions.selectedFunction {
                    self.presenter.respond(to: .calculatorKeyboard(.useSelectedAppearance(selectedCalculatorFunction, true)))
                }
                
                self.presenter.respond(to: .colorTheme(.active(self.persistedCalculatorData.settings.activeColorTheme)))
            case .pasteNumber:
                guard let term: TermProtocol = self.persistedCalculatorData.display.copiedNumber else { return }
                
                self.presenter.respond(to: .calculatorDisplay(.pastedNumber(term)))
            case .reload:
                break
            case .selectedCalculatorFuncion(let calculatorFunction):
                // Logic
                if self.persistedCalculatorData.functions.logicAnimationEnabled {
                    if self.persistedCalculatorData.functions.needsNumberValue && calculatorFunction.hasNumberValue == false {
                        return
                    }
                }
                // Displayed functions
                if let clearFunction = self.persistedCalculatorData.functions.updateDisplayedClearFunction(for: calculatorFunction) {
                    self.presenter.respond(to: .calculatorKeyboard(.clearFunction(clearFunction)))
                    if clearFunction == .allClear {
                        guard let selectedCalculatorFunction = self.persistedCalculatorData.functions.selectedFunction else { return }
                        self.presenter.respond(to: .calculatorKeyboard(.useSelectedAppearance(selectedCalculatorFunction, false)))
                    }
                }
                if let deselectedFunction = self.persistedCalculatorData.functions.deselectedCalculatorFunctionEvent(for: calculatorFunction) {
                    self.presenter.respond(to: .calculatorKeyboard(.useSelectedAppearance(deselectedFunction, false)))
                }
                if let selectedFunction = self.persistedCalculatorData.functions.selectCalculatorFunctionEvent(for: calculatorFunction) {
                    self.presenter.respond(to: .calculatorKeyboard(.useSelectedAppearance(selectedFunction, true)))
                }
                if let show2ndFunctions = self.persistedCalculatorData.functions.show2ndFunctionEvent(for: calculatorFunction) {
                    self.presenter.respond(to: .calculatorKeyboard(.show2ndFunctions(show2ndFunctions)))
                }
                if let siUnit = self.persistedCalculatorData.functions.siUnitEvent(for: calculatorFunction) {
                    self.presenter.respond(to: .calculatorKeyboard(.clearFunction(siUnit)))
                }
                
                // Arithmetic
                if let mutableNumber = self.persistedCalculatorData.arithmetic.displayTerm as? MutableNumber {
                    let calculatorFunctionCategory = CalculatorFunction.FunctionCategory(calculatorFunction: calculatorFunction)
                    if calculatorFunctionCategory == .digit || calculatorFunctionCategory == .decimal {
                        let digitCount: Int = mutableNumber.fractionArray.count + mutableNumber.integerArray.count
                        if digitCount == self.calculator.mutableNumberDigitMaximum {
                            return
                        }
                    }
                }
                self.persistedCalculatorData.arithmetic.evaluate(calculatorFunction: calculatorFunction)
                
                // Display
                self.persistedCalculatorData.display.displayNumber = self.persistedCalculatorData.arithmetic.displayTerm
                self.presenter.respond(to: .calculatorDisplay(.displayNumber(self.persistedCalculatorData.display.displayNumber)))
            case .userSwipedLeft(let onNumber):
                guard self.persistedCalculatorData.display.displayNumber.termType == .mutableNumber else { return }
                (self.persistedCalculatorData.display.displayNumber as? MutableNumber)?.removeLastValue(leftSwipeInOutputLabel: onNumber)
                self.presenter.respond(to: .calculatorDisplay(.displayNumber(self.persistedCalculatorData.display.displayNumber)))
            }
        }
        DispatchQueue.main.async {
            self.dataManager.persist(data: self.persistedCalculatorData)
        }
    }
}


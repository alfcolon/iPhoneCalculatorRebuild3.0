//
//  CalculatorFunctionKeyboard.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class CalculatorFunctionKeyboard: NSObject, NSSecureCoding {

    // MARK: - Properties
    
    var displayedClearFunction: CalculatorFunction = .allClear
    var displayedSIUnit: CalculatorFunction = .degrees
    var selectedFunction: CalculatorFunction? = nil
    var show2ndFunctions: Bool = false
    var logicAnimationEnabled: Bool = false
    var needsNumberValue: Bool = false
    
    // MARK: - InitFr
    
    override init() {
        super.init()
    }
    
    // MARK: - Methods

    func updateDisplayedClearFunction(for selectedCalculatorFunction: CalculatorFunction) -> CalculatorFunction? {
        guard selectedCalculatorFunction != .secondFunction else { return nil }
        switch true {
        // AC to Clear
        case self.displayedClearFunction == .allClear:
            guard selectedCalculatorFunction.hasNumberValue || selectedCalculatorFunction == .decimal || CalculatorFunction.FunctionCategory(calculatorFunction: selectedCalculatorFunction) == .basicOperator  else { return nil }
            self.displayedClearFunction = .clearEntry
            return .clearEntry
        // Clear to AC
        case selectedCalculatorFunction == .clearEntry && self.displayedClearFunction == .clearEntry:
            self.displayedClearFunction = .allClear
            return .allClear
        default:
            return nil
        }
    }

    func deselectedCalculatorFunctionEvent(for selectedCalculatorFunction: CalculatorFunction) -> CalculatorFunction? {
        guard selectedCalculatorFunction != .secondFunction else { return nil }
        guard selectedCalculatorFunction.hasNumberValue || selectedCalculatorFunction.hasSelectedAppearance || (selectedCalculatorFunction == .allClear && self.selectedFunction != nil) else { return nil }
        guard let lastSelectedCalculatorFunction = self.selectedFunction else { return nil }
        self.selectedFunction = nil
        return lastSelectedCalculatorFunction
    }

    func selectCalculatorFunctionEvent(for calculatorFunction: CalculatorFunction) -> CalculatorFunction? {
        guard calculatorFunction != .secondFunction else { return nil }
        guard calculatorFunction.hasSelectedAppearance else { return nil }

        self.selectedFunction = calculatorFunction

        return calculatorFunction
    }
    func show2ndFunctionEvent(for calculatorFunction: CalculatorFunction) -> Bool? {
        guard calculatorFunction == .secondFunction else { return nil }

        self.show2ndFunctions = !self.show2ndFunctions

        return self.show2ndFunctions
    }
    func siUnitEvent(for calculatorFunction: CalculatorFunction) -> CalculatorFunction? {
        guard calculatorFunction == .radians || calculatorFunction == .degrees else { return nil }
        self.displayedSIUnit = calculatorFunction

        return calculatorFunction
    }
    
    // MARK: - Transforming
    
    enum Key: String {
        case displayedClearFunction
        case displayedSIUnit
        case selectedFunction
        case shouldDisplaySecondSetOfFunctions
        case logicAnimationsEnabled
    }
    
    public static var supportsSecureCoding: Bool = true

    public required init?(coder: NSCoder) {
        self.displayedClearFunction = {
            guard let data = coder.decodeObject(of: NSString.self, forKey: Key.displayedClearFunction.rawValue) else { fatalError() }
            guard let clear = CalculatorFunction(rawValue: data) else { fatalError() }
            return clear
        }()
        self.displayedSIUnit = {
            guard let data = coder.decodeObject(of: NSString.self, forKey: Key.displayedSIUnit.rawValue) else { fatalError() }
            guard let siUnit = CalculatorFunction(rawValue: data) else { fatalError() }
            return siUnit
        }()
        self.selectedFunction = {
            guard let data = coder.decodeObject(of: NSString.self, forKey: Key.selectedFunction.rawValue) else { return nil }
            guard let calculatorFunction = CalculatorFunction(rawValue: data) else { fatalError() }
            return calculatorFunction
        }()
        self.show2ndFunctions = {
            guard let data = coder.decodeObject(of: NSNumber.self, forKey: Key.shouldDisplaySecondSetOfFunctions.rawValue) else { fatalError() }
            return data.boolValue
        }()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.displayedClearFunction.rawValue.nsString, forKey: Key.displayedClearFunction.rawValue)
        coder.encode(self.displayedSIUnit.rawValue.nsString, forKey: Key.displayedSIUnit.rawValue)
        if let selectedFunction = self.selectedFunction {
            coder.encode(selectedFunction.nsString, forKey: Key.selectedFunction.rawValue)
        }
        coder.encode(self.show2ndFunctions.number, forKey: Key.shouldDisplaySecondSetOfFunctions.rawValue)
    }
}


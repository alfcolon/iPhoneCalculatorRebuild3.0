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
	var showSecondFunctions: Bool = false
	var lastLogicAnimationsUpdate: Date?
	var lastLogicAnimationsStateSent: Bool?
	var logicAnimationsEnabled = false
	var hideNonNumbers = false
	
	// MARK: - Init
	
	override init() {
		super.init()
	}
	
	// MARK: - Methods
	
	func updateDisplayedClearFunction(for selectedCalculatorFunction: CalculatorFunction) -> CalculatorFunction? {
		switch true {
		// AC to Clear
		case selectedCalculatorFunction.hasNumberValue && self.displayedClearFunction == .allClear:
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
	
	func deselectedFunction(for selectedCalculatorFunction: CalculatorFunction) -> CalculatorFunction? {
		guard selectedCalculatorFunction != .secondFunction else { return nil }
		guard let lastSelectedCalculatorFunction = self.selectedFunction else { return nil }
		self.selectedFunction = nil
		return lastSelectedCalculatorFunction
	}
	
	func selectCalculatorFunctionIfNeeded(for calculatorFunction: CalculatorFunction) -> CalculatorFunction? {
		guard calculatorFunction != .secondFunction else { return nil }
		guard calculatorFunction.hasSelectedAppearance else { return nil }
		
		self.selectedFunction = calculatorFunction
		return calculatorFunction
	}
	func toggle2ndSetOfFunctionsIfNeeded(for calculatorFunction: CalculatorFunction) -> Bool? {
		guard calculatorFunction == .secondFunction else { return nil }
		
		let show2ndFunctions = !self.showSecondFunctions
		
		self.showSecondFunctions = show2ndFunctions
		
		return show2ndFunctions
	}
	func toggleSIUnitIfNeeded(for calculatorFunction: CalculatorFunction) -> CalculatorFunction? {
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
		self.showSecondFunctions = {
			guard let data = coder.decodeObject(of: NSNumber.self, forKey: Key.shouldDisplaySecondSetOfFunctions.rawValue) else { fatalError() }
			return data.boolValue
		}()
		self.logicAnimationsEnabled = {
			guard let data = coder.decodeObject(of: NSNumber.self, forKey: Key.logicAnimationsEnabled.rawValue) else { fatalError() }
			return data.boolValue
		}()
	}
	
	public func encode(with coder: NSCoder) {
		coder.encode(self.displayedClearFunction.rawValue.nsString, forKey: Key.displayedClearFunction.rawValue)
		coder.encode(self.displayedSIUnit.rawValue.nsString, forKey: Key.displayedSIUnit.rawValue)
		if let selectedFunction = self.selectedFunction {
			coder.encode(selectedFunction.nsString, forKey: Key.selectedFunction.rawValue)
		}
		coder.encode(self.showSecondFunctions.number, forKey: Key.shouldDisplaySecondSetOfFunctions.rawValue)
		coder.encode(self.logicAnimationsEnabled.number, forKey: Key.logicAnimationsEnabled.rawValue)
	}
}

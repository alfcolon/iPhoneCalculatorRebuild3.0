//
//  Calculator.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 11/17/21.
//

import Foundation

public class Calculator: NSObject, NSSecureCoding {
	
	// MARK: - Properties
	
	var arithmetic: CalculatorArithmetic
	var display: CalculatorDisplay
	var functions: CalculatorFunctionKeyboard
	var settings: CalculatorSettings
	
	// MARK: - Init
	
	override init() {
		self.arithmetic = CalculatorArithmetic()
		self.display = CalculatorDisplay()
		self.functions = CalculatorFunctionKeyboard()
		self.settings = CalculatorSettings()
	}
	
	// MARK: - Transforming
	
	enum Key: String {
		case arithmetic
		case display
		case functions
		case settings
	}
	
	public static var supportsSecureCoding: Bool = true

	public required init?(coder: NSCoder) {
		self.arithmetic = {
			guard let data = coder.decodeObject(of: CalculatorArithmetic.self, forKey: Key.arithmetic.rawValue) else { fatalError() }
			return data
		}()
		self.display = {
			guard let data = coder.decodeObject(of: CalculatorDisplay.self, forKey: Key.display.rawValue) else { fatalError() }
			return data
		}()
		self.functions = {
			guard let data = coder.decodeObject(of: CalculatorFunctionKeyboard.self, forKey: Key.functions.rawValue) else { fatalError() }
			return data
		}()
		self.settings = {
			guard let data = coder.decodeObject(of: CalculatorSettings.self, forKey: Key.settings.rawValue) else { fatalError() }
			return data
		}()

	}
	
	public func encode(with coder: NSCoder) {
		coder.encode(self.arithmetic, forKey: Key.arithmetic.rawValue)
		coder.encode(self.display, forKey: Key.display.rawValue)
		coder.encode(self.functions, forKey: Key.functions.rawValue)
		coder.encode(self.settings, forKey: Key.settings.rawValue)
	}
}

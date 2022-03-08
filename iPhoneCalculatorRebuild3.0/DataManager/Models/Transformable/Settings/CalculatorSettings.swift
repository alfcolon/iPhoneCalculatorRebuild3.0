//
//  CalculatorSettings.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class CalculatorSettings: NSObject, NSSecureCoding {

	// MARK: - Properties

	var activeColorTheme: CalculatorColorTheme
	var logicAnimationsOn: Bool

	// MARK: - Init

	override init() {
		self.activeColorTheme = CalculatorColorTheme.iPhone
		self.logicAnimationsOn = false
	}

	// MARK: - Transforming
	
	enum Key: String {
		case activeColorTheme
		case logicAnimationsOn
	}

	public static var supportsSecureCoding: Bool = true

	public required init?(coder: NSCoder) {
		self.activeColorTheme = {
			guard let data = coder.decodeObject(of: CalculatorColorTheme.self, forKey: Key.activeColorTheme.rawValue) else { fatalError() }
			return data
		}()
		self.logicAnimationsOn = {
			guard let data = coder.decodeObject(of: NSNumber.self, forKey: Key.logicAnimationsOn.rawValue) else { fatalError() }
			return data.boolValue
		}()
	}

	public func encode(with coder: NSCoder) {
		coder.encode(self.activeColorTheme, forKey: Key.activeColorTheme.rawValue)
		coder.encode(self.logicAnimationsOn.number, forKey: Key.logicAnimationsOn.rawValue)
	}
}

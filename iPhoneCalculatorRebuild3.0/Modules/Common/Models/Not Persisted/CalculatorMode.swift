//
//  CalculatorMode.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import UIKit

enum CalculatorMode: String {
	
	// MARK: - Models
	
	case scientific
	case standard
	
	// MARK: - Methods
	
	mutating func set(for viewSize: CGSize) {
		self = viewSize.width > viewSize.height ? .scientific : .standard
	}
	
	// MARK: - Info
	
	var functionCount: Int {
		switch self {
		case .scientific:
			return 49
		case .standard:
			return 19
		}
	}
	
	var mutableNumberDigitMaximum: Int {
		switch self {
		case .scientific:
			return 16
		case .standard:
			return 9
		}
	}
	
	
	// MARK: - Properties
	
	static var active: CalculatorMode = UIScreen.main.bounds.width > UIScreen.main.bounds.height ? .scientific : .standard
	static var lastContainerSize: CGSize!
}

//
//  Transformer.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/19/21.
//

import Foundation

final class CalculatorTransformer: NSSecureUnarchiveFromDataTransformer {

	static let name = NSValueTransformerName(rawValue: String(describing: CalculatorTransformer.self))

	override static var allowedTopLevelClasses: [AnyClass] {
		return [
			CalculatorSettings.self,
			CalculatorColorTheme.self,
			CalculatorFunctionKeyboard.self,
			CalculatorDisplay.self,
			Calculator.self,
			CalculatorArithmetic.self,
			CalculatorResult.self,
			DoubleNumber.self,
			FunctionOneInput.self,
			FunctionTwoInputs.self,
			MemoryRecall.self,
			MutableNumber.self,
			ParentheticalExpressionContainer.self,
			ParentheticalExpression.self,
			PercentageFunction.self,
			PrecedenceOperation.self,
			TrigonometricFunction.self
		]
	}
	
	override class func value(forKey key: String) -> Any? {
		return super.value(forKey: key)
	}

	public static func register() {
		let transformer = CalculatorTransformer()
		ValueTransformer.setValueTransformer(transformer, forName: name)
	}
}

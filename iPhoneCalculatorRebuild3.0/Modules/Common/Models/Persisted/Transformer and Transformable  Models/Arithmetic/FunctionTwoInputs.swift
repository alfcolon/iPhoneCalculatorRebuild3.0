//
//  FunctionTwoInputs.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class FunctionTwoInputs: NSObject, NSSecureCoding, TermProtocol {

	// MARK: - Properties

	let function: CalculatorFunction
	var input1: TermProtocol
	var input2: TermProtocol?

	// MARK: - Init

	init(function: CalculatorFunction, input1: TermProtocol) {
		self.function = function
		self.input1 = input1
		self.negateNumber = false
		self.termType = .functionTwoInputs
		self.termTestIdentifier = UUID()
	}
	
	// MARK: - Evaluate Function

	func evaluateFunction() -> Double? {
		guard let input1Double = self.input1.doubleValue else { return nil }
		guard let input2Double = self.input2?.doubleValue else { return nil }
		
		let evaluatedFunctionDoubleValue: Double? = {
			switch self.function {
			case .baseXPowerY:
				return pow(input1Double, input2Double)
			case .baseYPowerX:
				return pow(input2Double, input1Double)
			case .enterExponent:
				return pow(10, input2Double) * input1Double
			case .logBaseY:
				return log(input1Double) / log(input2Double)
			case .coefficientYRadicandX:
				return pow(input1Double, 1 / input2Double)
			default:
				fatalError("Function in term is not a function with 1 input or it the function with one input is not handled in the above cases")
			}
		}()
		return evaluatedFunctionDoubleValue
	}
	
	// MARK: - Term Protocol

	var doubleValue: Double? {
		guard let evaluatedDoubleValue = self.evaluateFunction() else { return nil }
		return evaluatedDoubleValue * self.negateNumber.signNegationDoubleValue
	}
	var negateNumber: Bool
	var termType: Term
	var termTestIdentifier: UUID
	
	// MARK: - Transforming
	
	enum Key: String {
		case input1
		case input1TermType
		case input2
		case input2TermType
		case termType
		case negateNumber
		case termTestIdentifier
		case function
	}
	public static var supportsSecureCoding: Bool { return true }

	public required init?(coder: NSCoder) {
		self.input1 = {
			guard let termType: Term = {
				guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.input1TermType.rawValue) else { fatalError() }
				guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
				return termType
			}() else { fatalError() }
			let termKey = Key.input1.rawValue
			switch termType {
			case .calculatorResult:
				guard let term = coder.decodeObject(of: CalculatorResult.self, forKey: termKey) else { fatalError() }
				return term
			case .constantNumber:
				guard let term = coder.decodeObject(of: DoubleNumber.self, forKey: termKey) else { fatalError() }
				return term
			case .double:
				guard let term = coder.decodeObject(of: DoubleNumber.self, forKey: termKey) else { fatalError() }
				return term
			case .functionOneInput:
				guard let term = coder.decodeObject(of: FunctionOneInput.self, forKey: termKey) else { fatalError() }
				return term
			case .functionTwoInputs:
				guard let term = coder.decodeObject(of: FunctionTwoInputs.self, forKey: termKey) else { fatalError() }
				return term
			case .memoryRecall:
				guard let term = coder.decodeObject(of: MemoryRecall.self, forKey: termKey) else { fatalError() }
				return term
			case .mutableNumber:
				guard let term = coder.decodeObject(of: MutableNumber.self, forKey: termKey) else { fatalError() }
				return term
			case .operation:
				guard let term = coder.decodeObject(of: PrecedenceOperation.self, forKey: termKey) else { fatalError() }
				return term
			case .parentheticalExpression:
				guard let term = coder.decodeObject(of: ParentheticalExpression.self, forKey: termKey) else { fatalError() }
				return term
			case .parentheticalExpressionContainer:
				guard let term = coder.decodeObject(of: ParentheticalExpressionContainer.self, forKey: termKey) else { fatalError() }
				return term
			case .percentageFunction:
				guard let term = coder.decodeObject(of: PercentageFunction.self, forKey: termKey) else { fatalError() }
				return term
			case .trigonometricFunction:
				guard let term = coder.decodeObject(of: TrigonometricFunction.self, forKey: termKey) else { fatalError() }
				return term
		}
			
		}()
		self.input2 = {
			guard let termType: Term = {
				guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.input2TermType.rawValue) else { return nil }
				guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
				return termType
			}() else { return nil }
			let termKey = Key.input2.rawValue
			switch termType {
			case .calculatorResult:
				guard let term = coder.decodeObject(of: CalculatorResult.self, forKey: termKey) else { fatalError() }
				return term
			case .constantNumber:
				guard let term = coder.decodeObject(of: DoubleNumber.self, forKey: termKey) else { fatalError() }
				return term
			case .double:
				guard let term = coder.decodeObject(of: DoubleNumber.self, forKey: termKey) else { fatalError() }
				return term
			case .functionOneInput:
				guard let term = coder.decodeObject(of: FunctionOneInput.self, forKey: termKey) else { fatalError() }
				return term
			case .functionTwoInputs:
				guard let term = coder.decodeObject(of: FunctionTwoInputs.self, forKey: termKey) else { fatalError() }
				return term
			case .memoryRecall:
				guard let term = coder.decodeObject(of: MemoryRecall.self, forKey: termKey) else { fatalError() }
				return term
			case .mutableNumber:
				guard let term = coder.decodeObject(of: MutableNumber.self, forKey: termKey) else { fatalError() }
				return term
			case .operation:
				guard let term = coder.decodeObject(of: PrecedenceOperation.self, forKey: termKey) else { fatalError() }
				return term
			case .parentheticalExpression:
				guard let term = coder.decodeObject(of: ParentheticalExpression.self, forKey: termKey) else { fatalError() }
				return term
			case .parentheticalExpressionContainer:
				guard let term = coder.decodeObject(of: ParentheticalExpressionContainer.self, forKey: termKey) else { fatalError() }
				return term
			case .percentageFunction:
				guard let term = coder.decodeObject(of: PercentageFunction.self, forKey: termKey) else { fatalError() }
				return term
			case .trigonometricFunction:
				guard let term = coder.decodeObject(of: TrigonometricFunction.self, forKey: termKey) else { fatalError() }
				return term
		}
			
		}()
		self.function = {
			guard let nsString = coder.decodeObject(of: NSString.self, forKey: Key.function.rawValue) else { fatalError() }
			guard let function: CalculatorFunction = .init(rawValue: String(nsString)) else { fatalError() }
			return function
		}()
		self.negateNumber = coder.decodeObject(of: NSNumber.self, forKey: Key.negateNumber.rawValue)!.boolValue
		self.termType = {
			guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.termType.rawValue) else { fatalError() }
			guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
			return termType
		}()
		self.termTestIdentifier = {
			guard let nsString = coder.decodeObject(of: NSString.self, forKey: Key.termTestIdentifier.rawValue) else { fatalError() }
			guard let uuid = UUID(uuidString: String(nsString)) else { fatalError() }
			return uuid
		}()
	}
	
	public func encode(with coder: NSCoder) {
		self.encodeTestProtocol(coder: coder)
		
		coder.encode(NSString(string: self.function.rawValue), forKey: Key.function.rawValue)

		coder.encode(NSNumber(value: self.input1.termType.rawValue), forKey: Key.input1TermType.rawValue)
		coder.encode(self.input1, forKey: Key.input1.rawValue)
		
		if let input2 = self.input2 {
			coder.encode(input2, forKey: Key.input2.rawValue)
			coder.encode(NSNumber(value: input2.termType.rawValue), forKey: Key.input2TermType.rawValue)
		}
	}
}

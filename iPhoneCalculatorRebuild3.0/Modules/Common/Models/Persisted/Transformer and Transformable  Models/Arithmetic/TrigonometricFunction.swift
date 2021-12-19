//
//  TrigonometricFunction.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class TrigonometricFunction: NSObject, NSSecureCoding, TermProtocol {

	// MARK: - Properties

	let function: CalculatorFunction
	var input1: TermProtocol
	var siUnit: CalculatorFunction

	// MARK: - Init

	init(function: CalculatorFunction, input1: TermProtocol, siUnit: CalculatorFunction) {
		self.function = function
		self.input1 = input1
		self.siUnit = siUnit
		self.termType = .trigonometricFunction
		self.termTestIdentifier = UUID()
		self.negateNumber = false
	}
	
	// MARK: - Methods

	func evaluateFunction() -> Double? {
		guard let input1DoubleValue = self.input1.doubleValue else { return nil }
		let evaluedFunctionDouble: Double? = {
			switch self.function {
			case .hyperbolicCosine:
				return cosh(input1DoubleValue)
			case .hyperbolicSine:
				return sinh(input1DoubleValue)
			case .hyperbolicTangent:
				return tanh(input1DoubleValue)
			case .inverseHyperbolicCosine:
				return acosh(input1DoubleValue)
			case .inverseHyperbolicSine:
				return asinh(input1DoubleValue)
			case .inverseHyperbolicTangent:
				return atanh(input1DoubleValue)
			case .inverseRightAngleCosine:
				return acos(input1DoubleValue)
			case .inverseRightAngleSine:
				return asin(input1DoubleValue)
			case .inverseRightAngleTangent:
				return atan(input1DoubleValue)
			case .rightAngleCosine:
				return cos(input1DoubleValue)
			case .rightAngleSine:
				return sin(input1DoubleValue)
			case .rightAngleTangent:
				return tan(input1DoubleValue)
			default:
				fatalError("Function in term is not a trigonometric function or trigonometric function is not handled in the above cases")
			}
		}()
		return evaluedFunctionDouble
	}
	
	// MARK: - Term Protocol
	
	var doubleValue: Double? {
		guard let evaluatedDoubleValue = self.evaluateFunction() else { return nil }
		return evaluatedDoubleValue * self.negateNumber.signNegationDoubleValue
	}
	var negateNumber: Bool
	var termType: Term
	var termTestIdentifier: UUID
	
	// MARK: - Transformable
	
	enum Key: String {
		case input1
		case input1TermType
		case siUnit
		case termType
		case negateNumber
		case termTestIdentifier
		case function
	}
	public static var supportsSecureCoding: Bool { return true }

	public required init?(coder: NSCoder) {
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
		self.input1 = {
			let termType: Term = {
				guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.input1TermType.rawValue) else { fatalError() }
				guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
				return termType
			}()
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
		self.function = {
			guard let nsString = coder.decodeObject(of: NSString.self, forKey: Key.function.rawValue) else { fatalError() }
			guard let function: CalculatorFunction = .init(rawValue: String(nsString)) else { fatalError() }
			return function
		}()
		self.siUnit = {
			guard let nsString = coder.decodeObject(of: NSString.self, forKey: Key.siUnit.rawValue) else { fatalError() }
			guard let function: CalculatorFunction = .init(rawValue: String(nsString)) else { fatalError() }
			return function
		}()
	}
	
	public func encode(with coder: NSCoder) {
		self.encodeTestProtocol(coder: coder)
		coder.encode(NSString(string: self.function.rawValue), forKey: Key.function.rawValue)
		coder.encode(NSString(string: self.siUnit.rawValue), forKey: Key.siUnit.rawValue)
		coder.encode(self.input1, forKey: Key.input1.rawValue)
		coder.encode(NSNumber(value: self.input1.termType.rawValue), forKey: Key.input1TermType.rawValue)
	}
}

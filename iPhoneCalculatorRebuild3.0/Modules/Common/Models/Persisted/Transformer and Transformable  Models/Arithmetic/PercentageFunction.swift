//
//  PercentageFunction.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class PercentageFunction: NSObject, NSSecureCoding, TermProtocol {

	// MARK: - Properties
	
	var termOf: TermProtocol
	var termPercent: TermProtocol
	
	// MARK: - Init
	
	init(termPercentOf100: TermProtocol) {
		self.termPercent = termPercentOf100
		self.termOf = DoubleNumber(doubleValue: 100)
		self.termType = .percentageFunction
		self.termTestIdentifier = UUID()
		self.negateNumber = false
	}
	
	init(termPercent: TermProtocol, ofTerm: TermProtocol) {
		self.termPercent = termPercent
		self.termOf = ofTerm
		self.termType = .percentageFunction
		self.termTestIdentifier = UUID()
		self.negateNumber = false
	}

	// MARK: - Methods
	
	func evaluateFunction() -> Double? {
		guard let ofNumber = self.termOf.doubleValue else { return nil }
		guard let nPercent = self.termPercent.doubleValue else { return nil }
		
		return nPercent * ofNumber
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
		case term
		case termType
		case negateNumber
		case termPercent
		case termPercentTermType
		case termOf
		case termOfTermType
		case termTestIdentifier
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
		self.termPercent = {
			let termType: Term = {
				guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.termPercentTermType.rawValue) else { fatalError() }
				guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
				return termType
			}()
			let termKey = Key.termPercent.rawValue
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
		self.termOf = {
			let termType: Term = {
				guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.termOfTermType.rawValue) else { fatalError() }
				guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
				return termType
			}()
			let termKey = Key.termOf.rawValue
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
	}
	
	public func encode(with coder: NSCoder) {
		self.encodeTestProtocol(coder: coder)
		coder.encode(self.termPercent, forKey: Key.termPercent.rawValue)
		coder.encode(NSNumber(value: self.termPercent.termType.rawValue), forKey: Key.termPercentTermType.rawValue)
		coder.encode(self.termOf, forKey: Key.termOf.rawValue)
		coder.encode(NSNumber(value: self.termOf.termType.rawValue), forKey: Key.termOfTermType.rawValue)
	}
}

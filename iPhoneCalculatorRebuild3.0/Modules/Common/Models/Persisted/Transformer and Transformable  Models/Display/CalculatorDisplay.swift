//
//  CalculatorDisplay.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class CalculatorDisplay: NSObject, NSSecureCoding {
	
	// MARK: - Properties
	
	var copiedNumber: TermProtocol?
	var displayNumber: TermProtocol
	
	// MARK: - Init
	
	override init() {
		self.displayNumber = MutableNumber(digit: .zero)
	}
	
	// MARK: - Transforming
	
	enum Key: String {
		case copiedNumber
		case copiedNumberTermType
		case displayNumber
		case displayNumberTermType
	}
	
	public static var supportsSecureCoding: Bool = true

	public required init?(coder: NSCoder) {
		self.copiedNumber = {
			let term: TermProtocol? = {
				guard let termType: Term = {
					guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.displayNumberTermType.rawValue) else { return nil }
					guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
					return termType
				}() else { return nil }
				
				let termKey = Key.displayNumber.rawValue
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
			return term
		}()
		self.displayNumber = {
			let term: TermProtocol = {
				guard let termType: Term = {
					guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.copiedNumberTermType.rawValue) else { fatalError() }
					guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
					return termType
				}() else { fatalError() }
				
				let termKey = Key.copiedNumber.rawValue
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
			return term
		}()
	}
	
	public func encode(with coder: NSCoder) {
		if let copiedNumber = self.copiedNumber {
			coder.encode(NSNumber(value: copiedNumber.termType.rawValue), forKey: Key.copiedNumberTermType.rawValue)
			coder.encode(copiedNumber, forKey: Key.copiedNumber.rawValue)
		}
		coder.encode(NSNumber(value: self.displayNumber.termType.rawValue), forKey: Key.displayNumberTermType.rawValue)
		coder.encode(self.displayNumber, forKey: Key.displayNumber.rawValue)
	}
}

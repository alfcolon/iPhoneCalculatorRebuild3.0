//
//  PrecedenceOperation.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class PrecedenceOperation: NSObject, NSSecureCoding, TermProtocol {
 
	// MARK: - Properties

	var reverseParentheticalExpression: ParentheticalExpression?
	var basicOperator: CalculatorFunction?
	var leftTerm: TermProtocol?
	var rightTerm: TermProtocol?
	
	// MARK: - Info
	
	var isEmpty: Bool { return self.leftTerm == nil && rightTerm == nil }
	var numberValueNeeded: Bool { return (self.basicOperator != nil && self.rightTerm == nil) || self.leftTerm == nil}
	var termToUpdate: TermProtocol? { return self.basicOperator == nil ? self.leftTerm : self.rightTerm }
	var lastTermAdded: TermProtocol? { return self.rightTerm != nil ? self.rightTerm : self.leftTerm }

	// MARK: - Init

	override init() {
		self.negateNumber = false
		self.termType = .operation
		self.termTestIdentifier = UUID()
	}
	
	convenience init(container: ParentheticalExpression? = nil, leftTerm: TermProtocol? = nil, rightTerm: TermProtocol? = nil, basicOperator: CalculatorFunction? = nil) {
		self.init()
		self.reverseParentheticalExpression = container
		self.leftTerm = leftTerm
		self.rightTerm = rightTerm
		self.basicOperator = basicOperator
	}
	
	// MARK: - Methods
	
	func add(newTerm: TermProtocol) {
		if self.basicOperator == nil {
			self.leftTerm = newTerm
		} else {
			self.rightTerm = newTerm
		}
	}
	
	func add(termReplacement: TermProtocol) {
		if self.rightTerm != nil {
			self.rightTerm = termReplacement
		} else {
			self.leftTerm = termReplacement
		}
	}
	
	func importValues(from precedenceOperation: PrecedenceOperation) {
		self.leftTerm = precedenceOperation.leftTerm
		self.basicOperator = precedenceOperation.basicOperator
		self.rightTerm = precedenceOperation.rightTerm
	}
	
	func termForNewParentheticalExpression() -> TermProtocol? {
		switch true {
		case self.rightTerm != nil:
			let term = self.rightTerm
			self.rightTerm = nil
			return term
		case (self.basicOperator == nil && self.leftTerm != nil):
			let term = self.leftTerm
			self.leftTerm = nil
			return term
		default:
			return nil
		}
	}
	
	func removeOperator() -> CalculatorFunction {
		guard let basicOperator = self.basicOperator else { fatalError() }
		return basicOperator
	}
	
	func removeRightTerm() -> TermProtocol? {
		guard let rightTerm = self.rightTerm else { fatalError() }
		return rightTerm
	}
	
	func removeLeftTerm() -> TermProtocol? {
		guard let leftTerm = self.leftTerm else { fatalError() }
		return leftTerm
	}
	
	// MARK: - Term Protocol
	
	var doubleValue: Double? {
		switch true {
		case self.isEmpty:
			fatalError()
		case (self.basicOperator == nil && self.rightTerm == nil):
			return self.leftTerm!.doubleValue
		default:
			guard let leftTermDoubleValue = self.leftTerm?.doubleValue else { return nil }
			guard let rightTermDoubleValue = self.rightTerm?.doubleValue else { return nil }
			
			switch self.basicOperator! {
			case .addition:
				return leftTermDoubleValue + rightTermDoubleValue
			case .subtraction:
				return leftTermDoubleValue - rightTermDoubleValue
			case .multiplication:
				return leftTermDoubleValue * rightTermDoubleValue
			case .division:
				guard rightTermDoubleValue != 0 else { return nil }
				return leftTermDoubleValue / rightTermDoubleValue
			default:
				fatalError()
			}
		}
	}
	var negateNumber: Bool
	var termType: Term
	var termTestIdentifier: UUID
	
	// MARK: - Transformable
	
	enum Key: String {
		case leftTerm
		case leftTermTermType
		case rightTerm
		case rightTermTermType
		case termType
		case negateNumber
		case termTestIdentifier
		case basicOperator
		case reverseParentheticalExpression
		case reverseParentheticalExpressionTermType
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
		self.leftTerm = {
			guard let termType: Term = {
				guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.leftTermTermType.rawValue) else { return nil }
				guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
				return termType
			}() else { return nil }
			let termKey = Key.leftTerm.rawValue
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
		self.rightTerm = {
			guard let termType: Term = {
				guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.rightTermTermType.rawValue) else { return nil }
				guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
				return termType
			}() else { return nil }
			let termKey = Key.rightTerm.rawValue
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
		self.basicOperator = {
			guard let nsString = coder.decodeObject(of: NSString.self, forKey: Key.basicOperator.rawValue) else { return nil }
			guard let function: CalculatorFunction = .init(rawValue: String(nsString)) else { fatalError() }
			return function
		}()
		self.reverseParentheticalExpression = coder.decodeObject(of: ParentheticalExpression.self, forKey: Key.reverseParentheticalExpression.rawValue)
	}
	
	public func encode(with coder: NSCoder) {
		self.encodeTestProtocol(coder: coder)
		
		if let leftTerm = self.leftTerm {
			coder.encode(leftTerm, forKey: Key.leftTerm.rawValue)
			coder.encode(NSNumber(value: leftTerm.termType.rawValue), forKey: Key.leftTermTermType.rawValue)
		}
		if let rightTerm = self.rightTerm {
			coder.encode(rightTerm, forKey: Key.rightTerm.rawValue)
			coder.encode(NSNumber(value: rightTerm.termType.rawValue), forKey: Key.rightTermTermType.rawValue)
		}
		
		if let basicOperator = self.basicOperator {
			coder.encode(NSString(string: basicOperator.rawValue), forKey: Key.basicOperator.rawValue)
		}
		
		if let reverseParentheticalExpression = self.reverseParentheticalExpression {
			coder.encode(reverseParentheticalExpression, forKey: Key.reverseParentheticalExpression.rawValue)
		}
	}
}

//
//  CalculatorResult.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class CalculatorResult: NSObject, NSSecureCoding, TermProtocol {
	
	// MARK: - Properties
	
	var term: TermProtocol!
	
	// MARK: - Init

	init(parentheticalExpressionContainers: ParentheticalExpressionContainer, displayTerm: TermProtocol) {
		self.negateNumber = false
		self.termType = .calculatorResult
		self.termTestIdentifier = UUID()
		
		var carryOverDoubleNumber: DoubleNumber? = {
			let currentPrecedence = parentheticalExpressionContainers.parentheticalExpressions.last!.currentPrecedenceOperation
			return currentPrecedence.numberValueNeeded ? DoubleNumber(term: displayTerm) : nil
		}()
		
		for parentheticalExpression in parentheticalExpressionContainers.parentheticalExpressions.reversed() {
			if parentheticalExpression.termTestIdentifier == parentheticalExpressionContainers.parentheticalExpressions.first?.termTestIdentifier {
				switch true {
				// operations
				case carryOverDoubleNumber != nil:
					let leftTerm = DoubleNumber(term: parentheticalExpression)
					let basicOperator = parentheticalExpression.currentPrecedenceOperation.removeOperator()
					let rightNumber = carryOverDoubleNumber
					self.term = PrecedenceOperation(leftTerm: leftTerm, rightTerm: rightNumber, basicOperator: basicOperator)
				case parentheticalExpression.high.basicOperator != nil:
					let rightNumber = parentheticalExpression.high.removeRightTerm()
					let basicOperator = parentheticalExpression.high.removeOperator()
					let leftTerm = DoubleNumber(term: parentheticalExpression)
					self.term = PrecedenceOperation(leftTerm: leftTerm, rightTerm: rightNumber, basicOperator: basicOperator)
				case parentheticalExpression.low.basicOperator != nil:
					let rightNumber = parentheticalExpression.high.leftTerm == nil ? parentheticalExpression.low.rightTerm : parentheticalExpression.high.leftTerm
					let basicOperator = parentheticalExpression.low.removeOperator()
					let leftTerm = parentheticalExpression.low.leftTerm
					self.term = PrecedenceOperation(leftTerm: leftTerm, rightTerm: rightNumber, basicOperator: basicOperator)
				// single term
				case parentheticalExpression.low.leftTerm != nil:
					self.term = parentheticalExpression.low.leftTerm!
				case parentheticalExpression.high.leftTerm != nil:
					self.term = parentheticalExpression.high.leftTerm!
				default:
					fatalError()
			}
				break
			} else if carryOverDoubleNumber != nil {
				parentheticalExpression.currentPrecedenceOperation.add(newTerm: carryOverDoubleNumber!)
				
				guard let doubleValue = parentheticalExpression.doubleValue else {
					self.term = DoubleNumber(doubleValue: nil)
					return
				}
				carryOverDoubleNumber = DoubleNumber(doubleValue: doubleValue)
			}
		}
	}
	
	// MARK: - Methods
	
	func continueTerm() {
		switch self.term.termType {
		case .functionOneInput:
			(self.term as! FunctionOneInput).input1 = DoubleNumber(doubleValue: self.doubleValue)
		case .functionTwoInputs:
			(self.term as! FunctionTwoInputs).input1 = DoubleNumber(doubleValue: self.doubleValue)
		case .trigonometricFunction:
			(self.term as! TrigonometricFunction).input1 = DoubleNumber(doubleValue: self.doubleValue)
		case .percentageFunction:
			(self.term as! PercentageFunction).termOf = DoubleNumber(doubleValue: self.doubleValue)
		case .operation:
			(self.term as! PrecedenceOperation).leftTerm = DoubleNumber(doubleValue: self.doubleValue)
		default:
			break
		}
	}
	
	// MARK: - TermProtocol
	
	var doubleValue: Double? {
		guard let evaluatedTermDouble = self.term.doubleValue else { return nil }
		return evaluatedTermDouble * (self.negateNumber ? -1 : 1)
	}
	var negateNumber: Bool
	var termType: Term
	var termTestIdentifier: UUID
	
	// MARK: - Transformable
	
	enum Key: String {
		case term
		case termType
		case negateNumber
		case termTermType
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
		self.term = {
			let termType: Term = {
				guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.termTermType.rawValue) else { fatalError() }
				guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
				return termType
			}()
			let termKey = Key.term.rawValue
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
		coder.encode(self.term, forKey: Key.term.rawValue)
		coder.encode(NSNumber(value: self.term.termType.rawValue), forKey: Key.termTermType.rawValue)
	}
}

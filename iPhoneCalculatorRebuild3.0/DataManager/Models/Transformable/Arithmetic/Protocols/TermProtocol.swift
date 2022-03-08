//
//  TermProtocol.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

enum Term: Int {
	case double
	case constantNumber
	case functionOneInput
	case functionTwoInputs
	case memoryRecall
	case mutableNumber
	case operation
	case parentheticalExpressionContainer
	case parentheticalExpression
	case percentageFunction
	case calculatorResult
	case trigonometricFunction
	
	static func term(for calculatorFunction: CalculatorFunction) -> Term {
		fatalError()
	}
	
	static var all: [Term] = [
		.parentheticalExpression,
		.parentheticalExpressionContainer,
		
		
		.percentageFunction,
		.double,
		.constantNumber,
		.functionOneInput,
		.functionTwoInputs,
		.memoryRecall,
		.mutableNumber,
		.operation,

		.calculatorResult,
		.trigonometricFunction
	]
}

protocol TermProtocol: NSSecureCoding {
	var doubleValue: Double? { get }
	var negateNumber: Bool { get set }
	var termType: Term { get set }
	var termTestIdentifier: UUID { get set }
}
extension TermProtocol {
	public func decodeTerm(coder: NSCoder, termKey: String, termTypeKey: String) -> TermProtocol? {
		let termType: Term? = {
		   guard let intValue: Int = coder.decodeObject(of: NSNumber.self, forKey: termTypeKey)?.intValue else { return nil }
		   guard let termType: Term = .init(rawValue: intValue) else { fatalError() }
		   return termType
		}()
		switch termType {
		case .none:
			return nil
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
   }
	
	func encodeTestProtocol(coder: NSCoder) {
		coder.encode(NSNumber(value: self.negateNumber), forKey: "negateNumber")
		coder.encode(NSNumber(value:self.termType.rawValue), forKey: "termType")
		coder.encode(self.termTestIdentifier.uuidString.nsString, forKey: "termTestIdentifier")
	}
}

//
//  DoubleNumber.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class DoubleNumber: NSObject, NSSecureCoding, TermProtocol {

	// MARK: - Models
	
	enum Source {
		enum Key: Int {
			case constant
			case double
			case term
			case parentheticalExpressionValue
			case precedenceOperationValue
			
			
			enum AssociatedValueKey: String {
				case sourceTerm
				case sourceTermType
				case sourceDoubleValue
				case sourceCalculatorFunction
			}
			
		}
		case constant(CalculatorFunction, Double)
		case double(Double?)
		case term(TermProtocol, Double?)
		case parentheticalExpressionValue(Double?)
		case precedenceOperationValue(Double?)
		
		var replacableByMutableNumber: Bool {
			switch self {
			case .constant:
				return false
			default:
				return true
			}
		}
		var doubleValue: Double? {
			switch self {
			case .constant(_, let doubleValue):
				return doubleValue
			case .double(let doubleValue):
				return doubleValue
			case .parentheticalExpressionValue(let doubleValue):
				return doubleValue
			case .precedenceOperationValue(let doubleValue):
				return doubleValue
			case .term(_, let doubleValue):
				return doubleValue
			}
		}
		
		var term: TermProtocol? {
			switch self {
			case .term(let term, _):
				return term
			default:
				return nil
			}
		}
		
		var constant: CalculatorFunction? {
			switch self {
			case .constant(let calculatorFunction, _):
				return calculatorFunction
			default:
				return nil
			}
		}
		
		var key: Key {
			switch self {
			case .constant:
				return .constant
			case .double:
				return .double
			case .parentheticalExpressionValue:
				return .parentheticalExpressionValue
			case .precedenceOperationValue:
				return .precedenceOperationValue
			case .term:
				return .term
			}
		}
	}
	
	// MARK: - Properties

	var source: Source!
		
	// MARK: - Init
	
	private init(source: Source) {
		self.source = source
		self.negateNumber = false
		self.termType = .double
		self.termTestIdentifier = UUID()
	}
	convenience init(doubleValue: Double?) {
		let source: Source = .double(doubleValue)
		self.init(source: source)
	}
	
	convenience init(constant: CalculatorFunction) {
		let doubleValue: Double = {
			switch constant {
			case .eulersNumber:
				return Darwin.M_E
			case .pi:
				return Double.pi
			case .randomNumber:
				return Double.random(in: 0..<1)
			default:
				fatalError()
			}
		}()
		let source: Source = .constant(constant, doubleValue)
		self.init(source: source)
	}
	
	convenience init(term: TermProtocol) {
		let source: Source = .term(term, term.doubleValue)
		self.init(source: source)
	}

	convenience init(precedenceOperation: TermProtocol) {
		let source: Source = .precedenceOperationValue(precedenceOperation.doubleValue)
		self.init(source: source)
	}
	convenience init(parentheticalExpression: TermProtocol) {
		let source: Source = .parentheticalExpressionValue(parentheticalExpression.doubleValue)
		self.init(source: source)
	}
	
	// MARK: - Term Protocols
	
	var doubleValue: Double? {
		get {
			guard let sourceDoubleValue = self.source.doubleValue else { return nil }
			return sourceDoubleValue * self.negateNumber.signNegationDoubleValue
		}
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
		case sourceType
		case source
		
	}
	public static var supportsSecureCoding: Bool { return true }

	public required init?(coder: NSCoder) {
		self.termType = {
			guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.termType.rawValue) else { fatalError() }
			guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
			return termType
		}()
		self.negateNumber = {
			guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.negateNumber.rawValue) else { fatalError() }
			return number.boolValue
		}()
		self.termTestIdentifier = {
			guard let nsString = coder.decodeObject(of: NSString.self, forKey: Key.termTestIdentifier.rawValue) else { fatalError() }
			guard let uuid = UUID(uuidString: String(nsString)) else { fatalError() }
			return uuid
		}()
		self.source = {
			let sourceType: Source.Key = {
				guard let int: Int = coder.decodeObject(of: NSNumber.self, forKey: Key.sourceType.rawValue)?.intValue else { fatalError() }
				guard let sourceType = Source.Key.init(rawValue: int) else { fatalError() }
				return sourceType
			}()
			switch sourceType {
			case .constant:
				let calculatorFunction: CalculatorFunction = {
					guard let nsString: NSString = coder.decodeObject(of: NSString.self, forKey: Source.Key.AssociatedValueKey.sourceCalculatorFunction.rawValue) else { fatalError() }
					guard let calculatorFunction: CalculatorFunction = .init(rawValue: String(nsString)) else { fatalError() }
					return calculatorFunction
				}()
				let doubleValue: Double! = coder.decodeObject(of: NSNumber.self, forKey: Source.Key.AssociatedValueKey.sourceDoubleValue.rawValue)?.doubleValue
				return .constant(calculatorFunction, doubleValue)
			case .double:
				let doubleValue: Double? = coder.decodeObject(of: NSNumber.self, forKey: Source.Key.AssociatedValueKey.sourceDoubleValue.rawValue)?.doubleValue
				return .double(doubleValue)
			case .parentheticalExpressionValue:
				let doubleValue: Double? = coder.decodeObject(of: NSNumber.self, forKey: Source.Key.AssociatedValueKey.sourceDoubleValue.rawValue)?.doubleValue
				return .parentheticalExpressionValue(doubleValue)
			case .precedenceOperationValue:
				let doubleValue: Double? = coder.decodeObject(of: NSNumber.self, forKey: Source.Key.AssociatedValueKey.sourceDoubleValue.rawValue)?.doubleValue
				return .precedenceOperationValue(doubleValue)
			case .term:
				let doubleValue: Double? = coder.decodeObject(of: NSNumber.self, forKey: Source.Key.AssociatedValueKey.sourceDoubleValue.rawValue)?.doubleValue
				let term: TermProtocol = {
					guard let termType: Term = {
						guard let number = coder.decodeObject(of: NSNumber.self, forKey: Source.Key.AssociatedValueKey.sourceTermType.rawValue) else { fatalError() }
						guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
						return termType
					}() else { fatalError() }
					let termKey = Source.Key.AssociatedValueKey.sourceTerm.rawValue
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
				return .term(term, doubleValue)
			}
		}()
	}
	
	public func encode(with coder: NSCoder) {
		self.encodeTestProtocol(coder: coder)
		
		coder.encode(NSNumber(value: self.source.key.rawValue), forKey: Key.sourceType.rawValue)
		switch self.source {
		case .constant(let calculatorFunction, let doubleValue):
			coder.encode(calculatorFunction.rawValue.nsString, forKey: Source.Key.AssociatedValueKey.sourceCalculatorFunction.rawValue)
			coder.encode(NSNumber(value: doubleValue), forKey: Source.Key.AssociatedValueKey.sourceDoubleValue.rawValue)
		case .double(let doubleValue):
			if let doubleValue = doubleValue {
				coder.encode(NSNumber(value: doubleValue), forKey: Source.Key.AssociatedValueKey.sourceDoubleValue.rawValue)
			}
		case .parentheticalExpressionValue(let doubleValue):
			if let doubleValue = doubleValue {
				coder.encode(NSNumber(value: doubleValue), forKey: Source.Key.AssociatedValueKey.sourceDoubleValue.rawValue)
			}
		case .precedenceOperationValue(let doubleValue):
			if let doubleValue = doubleValue {
				coder.encode(NSNumber(value: doubleValue), forKey: Source.Key.AssociatedValueKey.sourceDoubleValue.rawValue)
			}
		case .term(let term, let doubleValue):
			if let doubleValue = doubleValue {
				coder.encode(NSNumber(value: doubleValue), forKey: Source.Key.AssociatedValueKey.sourceDoubleValue.rawValue)
			}
			coder.encode(NSNumber(value: term.termType.rawValue), forKey: Source.Key.AssociatedValueKey.sourceTermType.rawValue)
			coder.encode(term, forKey: Source.Key.AssociatedValueKey.sourceTerm.rawValue)
		case .none:
			fatalError()
		}
	}
}

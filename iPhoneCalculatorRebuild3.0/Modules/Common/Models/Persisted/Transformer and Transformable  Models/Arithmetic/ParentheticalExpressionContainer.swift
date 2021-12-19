//
//  ParentheticalExpressionContainer.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class ParentheticalExpressionContainer: NSObject, NSSecureCoding, TermProtocol {

	// MARK: - Properties
	
	var parentheticalExpressions: [ParentheticalExpression] = []
	var reverseFunctionTwoInputs: FunctionTwoInputs?
	
	// MARK: - Init
	
	init(reverseFunctionTwoInputs: FunctionTwoInputs?, startingTerm: TermProtocol?) {
		self.parentheticalExpressions = []
		
		self.reverseFunctionTwoInputs = reverseFunctionTwoInputs
		self.negateNumber = false
		self.termType = .parentheticalExpressionContainer
		self.termTestIdentifier = UUID()
		super.init()
		self.parentheticalExpressions.append(ParentheticalExpression(container: self, startingTerm: startingTerm))
	}
	
	// MARK: - Info
	
	var lastParentheticalExpressionWithValue: ParentheticalExpression? {
		var index = self.parentheticalExpressions.count - 1
		
		while index >= 0 {
			if self.parentheticalExpressions[index].isEmpty == false {
				return self.parentheticalExpressions[index]
			}
			index -= 1
		}
		
		return nil
	}
	var isEmpty: Bool {
		for parentheticalExpression in self .parentheticalExpressions {
			if parentheticalExpression.isEmpty == false {
				return false
			}
		}
		return true
	}

	// MARK: - Term Protocol Properties
	
	var doubleValue: Double? {
		var doubleToAdd: Double?
		for parentheticalExpression in self.parentheticalExpressions.reversed() {
			if parentheticalExpression.isEmpty == false {
				if doubleToAdd != nil {
					parentheticalExpression.currentPrecedenceOperation.add(newTerm: DoubleNumber(doubleValue: doubleToAdd!))
				}
				guard let evaluatedDouble = parentheticalExpression.doubleValue else { fatalError() }
				doubleToAdd = evaluatedDouble
			}
		}
		return doubleToAdd
	}
	var negateNumber: Bool
	var termType: Term
	var termTestIdentifier: UUID
	
	// MARK: - Methods
	
	func addParentheticalExpression(startingTerm: TermProtocol?) {
		let parentheticalExpression = ParentheticalExpression(container: self, startingTerm: startingTerm)
		self.parentheticalExpressions.append(parentheticalExpression)
	}
	
	// MARK: - Transforming
	
	enum Key: String {
		case parentheticalExpressions
		case termType
		case negateNumber
		case termTestIdentifier
		case reverseFunctionTwoInputs
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
		self.parentheticalExpressions = {
			guard let test = coder.decodeObject(of: [NSArray.self, ParentheticalExpression.self], forKey: Key.parentheticalExpressions.rawValue) else { fatalError() }
			return Array(_immutableCocoaArray: test as! NSArray)
		}()
		self.reverseFunctionTwoInputs = coder.decodeObject(of: FunctionTwoInputs.self, forKey: Key.reverseFunctionTwoInputs.rawValue)
	}

	public func encode(with coder: NSCoder) {
		self.encodeTestProtocol(coder: coder)

		coder.encode(self.parentheticalExpressions, forKey: Key.parentheticalExpressions.rawValue)
		
		if let reverse = self.reverseFunctionTwoInputs {
			coder.encode(reverse, forKey: Key.reverseFunctionTwoInputs.rawValue)
		}
	}
}



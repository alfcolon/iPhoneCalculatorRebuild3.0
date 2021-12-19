//
//  MutableNumber.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class MutableNumber: NSObject, NSSecureCoding, TermProtocol {

	// MARK: - Properties

	var decimalAdded: Bool
	var fractionArray: [String]
	var integerArray: [String]

	// MARK: - Init

	private init(digit: CalculatorFunction, shouldToggleNumberSign: Bool, decimalAdded: Bool) {
		self.fractionArray = []
		self.integerArray = []
		self.integerArray.append(digit.rawValue)
		self.negateNumber = shouldToggleNumberSign
		self.decimalAdded = decimalAdded
		self.termType = .mutableNumber
		self.termTestIdentifier = UUID()
	}
	convenience init(decimalAdded: Bool) {
		self.init(digit: .zero, shouldToggleNumberSign: false, decimalAdded: decimalAdded)
	}
	convenience init(shouldToggleNumberSign: Bool) {
		self.init(digit: .zero, shouldToggleNumberSign: shouldToggleNumberSign, decimalAdded: false)
	}
	convenience init(digit: CalculatorFunction) {
		self.init(digit: digit, shouldToggleNumberSign: false, decimalAdded: false)
	}
	
	// MARK: - Methods
	
	func addDecimal() {
		guard self.decimalAdded == false else { return }
		self.decimalAdded.toggle()
	}
	
	func addDigit(digit: CalculatorFunction) {
		// Avoid going over digitMax's
		let digitCount: Int = self.fractionArray.count + self.integerArray.count
		let digitMaximum: Int = CalculatorMode.active.mutableNumberDigitMaximum
		guard digitCount < digitMaximum else { return }
		
		// Avoid a double zero situation
		let doubleZero: Bool = digit == .zero && self.decimalAdded == false && self.integerArray == ["0"]
		guard doubleZero == false else { return }
		
		if self.decimalAdded {
			self.fractionArray.append(digit.rawValue)
		} else {
			// avoid leading zero
			if self.integerArray == ["0"] {
				self.integerArray[0] = digit.rawValue
			} else {
				self.integerArray.append(digit.rawValue)
			}
		}
	}
	
	func removeLastValue(leftSwipeInOutputLabel: Bool) {
		switch true {
		case self.fractionArray.count > 0:
			self.fractionArray.removeLast()
		case self.decimalAdded == true:
			self.decimalAdded = false
		case self.integerArray.count > 1:
			self.integerArray.removeLast()
		case leftSwipeInOutputLabel && self.integerArray == ["0"] && self.negateNumber:
			self.negateNumber.toggle()
		default:
			self.integerArray[0] = "0"
		}
	}
	
	// MARK: - Term Protocol
	
	var doubleValue: Double? {
		get {
			let doubleArray: [String] = decimalAdded ? integerArray + ["."] + fractionArray : integerArray
			let double: Double! = Double(doubleArray.joined())
			
			return self.negateNumber ? -double : double
		}
	}
	var negateNumber: Bool
	var termType: Term
	var termTestIdentifier: UUID
	
	// MARK: - Transforming
	
	enum Key: String {
		case decimalAdded
		case fractionArray
		case integerArray
		case negateNumber
		case termType
		case termTestIdentifier
	}
	
	public static var supportsSecureCoding: Bool = true

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
		self.integerArray = {
			guard let nsString = coder.decodeObject(of: NSString.self, forKey: Key.integerArray.rawValue) else { fatalError() }
			let string: String = String(nsString)
			let stringArray: [String] = string.map { return String($0) }
			return stringArray
		}()
		self.fractionArray = {
			guard let nsString = coder.decodeObject(of: NSString.self, forKey: Key.fractionArray.rawValue) else { fatalError() }
			let string: String = String(nsString)
			let stringArray: [String] = string.map { return String($0) }
			return stringArray
		}()
		self.decimalAdded = {
			guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.negateNumber.rawValue) else { fatalError() }
			return number.boolValue
		}()
	}
	public func encode(with coder: NSCoder) {
		self.encodeTestProtocol(coder: coder)
		coder.encode(NSNumber(value: self.decimalAdded), forKey: Key.decimalAdded.rawValue)
		coder.encode(NSString(string: self.integerArray.joined()), forKey: Key.integerArray.rawValue)
		coder.encode(NSString(string: self.fractionArray.joined()), forKey: Key.fractionArray.rawValue)
	}
}

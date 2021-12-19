//
//  File.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class MemoryRecall: NSObject, NSSecureCoding, TermProtocol {
	
	// MARK: - Properites

	var memoryDouble: Double?
	
	// MARK: - Init

	init(doubleValue: Double?) {
		self.memoryDouble = doubleValue
		self.negateNumber = false
		self.termType = .memoryRecall
		self.termTestIdentifier = UUID()
	}

	// MARK: - Methods

	func clear() {
		self.memoryDouble = 0
	}
	
	func decrease(by double: Double?) {
		guard let currentDoubleValue = self.doubleValue else { return }
		guard let newDouble = double else { return }
		self.memoryDouble = currentDoubleValue - newDouble
	}

	func increase(by double: Double?) {
		guard let currentDoubleValue = self.doubleValue else { return }
		guard let newDouble = double else { return }
		self.memoryDouble = currentDoubleValue + newDouble
	}
	
	// MARK: - Term Protocol
	
	var doubleValue: Double? {
		guard let memoryDouble = self.memoryDouble else { return nil }
		return memoryDouble * self.negateNumber.signNegationDoubleValue
	}
	var negateNumber: Bool
	var termType: Term
	var termTestIdentifier: UUID
	
	// MARK: - Transforming
	
	enum Key: String {
		case memoryDouble
		case termType
		case termTestIdentifier
		case negateNumber
	}
	
	public static var supportsSecureCoding: Bool = true
	
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
		self.memoryDouble = {
			guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.memoryDouble.rawValue) else { return nil }
			return number.doubleValue
		}()
	}

	public func encode(with coder: NSCoder) {
		self.encodeTestProtocol(coder: coder)
		if let doubleValue = self.doubleValue {
			coder.encode(NSNumber(value: doubleValue), forKey: Key.memoryDouble.rawValue)
		}
	}
}

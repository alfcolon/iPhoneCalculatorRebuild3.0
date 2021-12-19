//
//  ArithmeticModelTransformingTests.swift
//  UnitTests
//
//  Created by Alfredo Colon on 12/19/21.
//

import Foundation
import XCTest
@testable import iPhoneCalculatorRebuild3_0

class ArithmeticModelTransformingTests: XCTestCase {

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testTerms() {
		for term in Term.all {
			switch term {
			case .parentheticalExpression:
				let container = ParentheticalExpressionContainer(reverseFunctionTwoInputs: nil, startingTerm: nil)
				let parentheticalExpression = ParentheticalExpression(container: container, startingTerm: DoubleNumber(doubleValue: 1))
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: parentheticalExpression, requiringSecureCoding: true)
					do {
						let unarchivedData: ParentheticalExpression? = try NSKeyedUnarchiver.unarchivedObject(ofClass: ParentheticalExpression.self, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					XCTAssertTrue(false)
				}
			case .parentheticalExpressionContainer:
				let parentheticalExpressionContainer = ParentheticalExpressionContainer(reverseFunctionTwoInputs: nil, startingTerm: DoubleNumber(doubleValue: 1))
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: parentheticalExpressionContainer, requiringSecureCoding: true)
					do {
						let type = ParentheticalExpressionContainer.self
						let unarchivedData: ParentheticalExpressionContainer? = try NSKeyedUnarchiver.unarchivedObject(ofClass: type, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					XCTAssertTrue(false)
				}
			case .calculatorResult:
				let calculatorArithmetic = CalculatorArithmetic()
				calculatorArithmetic.evaluate(calculatorFunction: .one)
				calculatorArithmetic.evaluate(calculatorFunction: .addition)
				calculatorArithmetic.evaluate(calculatorFunction: .one)
				calculatorArithmetic.evaluate(calculatorFunction: .addition)
				calculatorArithmetic.evaluate(calculatorFunction: .two)
				calculatorArithmetic.evaluate(calculatorFunction: .multiplication)
				
				let calculatorResult = CalculatorResult(parentheticalExpressionContainers: calculatorArithmetic.arithmeticValues.parentheticalExpressionContainers.first!, displayTerm: calculatorArithmetic.displayTerm)
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: calculatorResult, requiringSecureCoding: true)
					do {
						let unarchivedData: CalculatorResult? = try NSKeyedUnarchiver.unarchivedObject(ofClass: CalculatorResult.self, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					let error = error
					print(error)
					XCTAssertTrue(false)
				}
			case .constantNumber:
				fallthrough
			case .double:
				let operation = PrecedenceOperation(container: nil, leftTerm: DoubleNumber(doubleValue: 2), rightTerm: DoubleNumber(doubleValue: 2), basicOperator: .multiplication)
				let double = DoubleNumber(term: operation)
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: double, requiringSecureCoding: true)
					do {
						let unarchivedData: DoubleNumber? = try NSKeyedUnarchiver.unarchivedObject(ofClass: DoubleNumber.self, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					XCTAssertTrue(false)
				}
				
				
				let doubleNumber = DoubleNumber(doubleValue: 1)
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: doubleNumber, requiringSecureCoding: true)
					do {
						let unarchivedData: DoubleNumber? = try NSKeyedUnarchiver.unarchivedObject(ofClass: DoubleNumber.self, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					XCTAssertTrue(false)
				}
			case .functionOneInput:
				let functionOneInput = FunctionOneInput(function: .baseXPowerTwo, input1: DoubleNumber(doubleValue: 1))
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: functionOneInput, requiringSecureCoding: true)
					do {
						let unarchivedData: FunctionOneInput? = try NSKeyedUnarchiver.unarchivedObject(ofClass: FunctionOneInput.self, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					XCTAssertTrue(false)
				}
			case .functionTwoInputs:
				let term = MutableNumber(digit: .one)
				let functionTwoInputs = FunctionTwoInputs(function: .baseXPowerY, input1: term)
				functionTwoInputs.input2 = term
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: functionTwoInputs, requiringSecureCoding: true)
					do {
						let unarchivedData: FunctionTwoInputs? = try NSKeyedUnarchiver.unarchivedObject(ofClass: FunctionTwoInputs.self, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					XCTAssertTrue(false)
				}
			case .memoryRecall:
				let memoryRecall = MemoryRecall(doubleValue: 1)
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: memoryRecall, requiringSecureCoding: true)
					do {
						let unarchivedData: MemoryRecall? = try NSKeyedUnarchiver.unarchivedObject(ofClass: MemoryRecall.self, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					XCTAssertTrue(false)
				}
			case .mutableNumber:
				let mutableNumber = MutableNumber(digit: .zero)
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: mutableNumber, requiringSecureCoding: true)
					do {
						let unarchivedData: MutableNumber? = try NSKeyedUnarchiver.unarchivedObject(ofClass: MutableNumber.self, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					XCTAssertTrue(false)
				}
			case .operation:
				let calculatorArithmetic = CalculatorArithmetic()
				calculatorArithmetic.evaluate(calculatorFunction: .one)
				calculatorArithmetic.evaluate(calculatorFunction: .addition)
				calculatorArithmetic.evaluate(calculatorFunction: .one)
				calculatorArithmetic.evaluate(calculatorFunction: .addition)
				calculatorArithmetic.evaluate(calculatorFunction: .two)
				calculatorArithmetic.evaluate(calculatorFunction: .multiplication)
				calculatorArithmetic.evaluate(calculatorFunction: .two)
				calculatorArithmetic.evaluate(calculatorFunction: .multiplication)
				calculatorArithmetic.evaluate(calculatorFunction: .two)
				
				let operation1 = calculatorArithmetic.arithmeticValues.currentPrecedenceOperation
				
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: operation1, requiringSecureCoding: true)
					do {
						let unarchivedData: PrecedenceOperation? = try NSKeyedUnarchiver.unarchivedObject(ofClass: PrecedenceOperation.self, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					XCTAssertTrue(false)
				}
				
				let term = DoubleNumber(doubleValue: 1)
				let operation = PrecedenceOperation(container: nil, leftTerm: term, rightTerm: term, basicOperator: .addition)
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: operation, requiringSecureCoding: true)
					do {
						let unarchivedData: PrecedenceOperation? = try NSKeyedUnarchiver.unarchivedObject(ofClass: PrecedenceOperation.self, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					XCTAssertTrue(false)
				}
			case .percentageFunction:
				let percentageFunction = PercentageFunction(termPercentOf100: DoubleNumber(doubleValue: 1))
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: percentageFunction, requiringSecureCoding: true)
					do {
						let unarchivedData: PercentageFunction? = try NSKeyedUnarchiver.unarchivedObject(ofClass: PercentageFunction.self, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					XCTAssertTrue(false)
				}
			case .trigonometricFunction:
				let trigonometricFunction = TrigonometricFunction(function: .rightAngleSine, input1: DoubleNumber(doubleValue: 1), siUnit: .degrees)
				do {
					let archivedData = try NSKeyedArchiver.archivedData(withRootObject: trigonometricFunction, requiringSecureCoding: true)
					do {
						let unarchivedData: TrigonometricFunction? = try NSKeyedUnarchiver.unarchivedObject(ofClass: TrigonometricFunction.self, from: archivedData)
						XCTAssertTrue(unarchivedData != nil)
					} catch {
						XCTAssertTrue(false)
					}
				} catch {
					XCTAssertTrue(false)
				}
			}
		}
	}
	
	func testArithmetic() {
		let calculatorArithmetic = CalculatorArithmetic()
		calculatorArithmetic.evaluate(calculatorFunction: .one)
		calculatorArithmetic.evaluate(calculatorFunction: .addition)
		calculatorArithmetic.evaluate(calculatorFunction: .one)
		calculatorArithmetic.evaluate(calculatorFunction: .addition)
		calculatorArithmetic.evaluate(calculatorFunction: .two)
		calculatorArithmetic.evaluate(calculatorFunction: .multiplication)
		
		do {
			let archivedData = try NSKeyedArchiver.archivedData(withRootObject: calculatorArithmetic, requiringSecureCoding: true)
			do {
				let unarchivedData: CalculatorArithmetic? = try NSKeyedUnarchiver.unarchivedObject(ofClass: CalculatorArithmetic.self, from: archivedData)
				XCTAssertTrue(unarchivedData != nil)
			} catch {
				XCTAssertTrue(false)
			}
		} catch {
			let error = error
			print("\n\(error)\n")
			XCTAssertTrue(false)
		}
	}
}

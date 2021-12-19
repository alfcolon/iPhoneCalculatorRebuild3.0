//
//  ArithmeticTests.swift
//  UnitTests
//
//  Created by Alfredo Colon on 12/19/21.
//

import Foundation
import XCTest
@testable import iPhoneCalculatorRebuild3_0

class ArithmeticTests: XCTestCase {

	// MARK: - Properties
	
	var arithmetic = CalculatorArithmetic()
	var termToUpdate: TermProtocol? {
		return self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate
	}
	
	// MARK: - Setup
	
	override func setUpWithError() throws {
		continueAfterFailure = true
	}
	
	// MARK: - Tests
	
	func testBasicOperator() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.BasicOperatorUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .addAfterRefactoringHighPrecedenceToLeftTermAsDoubleNumber:
				let _	  		: Void?					=	self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _	  		: Void?					=	self.arithmetic.evaluate(calculatorFunction: .pi)
				let pi			: TermProtocol?			=	self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate
				let _	  		: Void?					=	self.arithmetic.evaluate(calculatorFunction: .multiplication)
				let _	  		: Void?					=	self.arithmetic.evaluate(calculatorFunction: .one)
				let one			: TermProtocol?			=	self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate
				let updateCase	: ArithmeticUpdate		=	.arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation, basicOperator: .division)
				let _	 		: Void?					=	self.arithmetic.evaluate(calculatorFunction: .division)
				let leftTerm 	: DoubleNumber?			= 	self.arithmetic.arithmeticValues.currentParentheticalExpression.high.leftTerm as? DoubleNumber
				let operation	: PrecedenceOperation	=	leftTerm?.source.term as! PrecedenceOperation
				
				XCTAssertTrue(updateCase == update)
				XCTAssertTrue(leftTerm 	!= 	nil)
				XCTAssertTrue(operation.leftTerm?.termTestIdentifier == pi?.termTestIdentifier)
				XCTAssertTrue(operation.rightTerm?.termTestIdentifier == one?.termTestIdentifier)
				XCTAssertTrue(operation.basicOperator	== .multiplication)
				XCTAssertTrue(self.arithmetic.arithmeticValues.currentParentheticalExpression.high.basicOperator	==	.division)
			case .addAfterRefactoringLowPrecedenceToLeftTermAsOperation:
				let _	  		: Void					=	self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _	  		: Void					=	self.arithmetic.evaluate(calculatorFunction: .pi)
				let pi			: TermProtocol			=	self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate!
				let _	 		: Void					=	self.arithmetic.evaluate(calculatorFunction: .addition)
				let _	  		: Void					=	self.arithmetic.evaluate(calculatorFunction: .one)
				let one			: TermProtocol			=	self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate!
				let updateCase	: ArithmeticUpdate		=	.arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation, basicOperator: .subtraction)
				let _	 		: Void					=	self.arithmetic.evaluate(calculatorFunction: .subtraction)
				let operation 	: PrecedenceOperation	= 	self.self.arithmetic.arithmeticValues.currentPrecedenceOperation.leftTerm as! PrecedenceOperation
				
				XCTAssertTrue(updateCase == update)
				XCTAssertTrue(operation.leftTerm?.termTestIdentifier ==	pi.termTestIdentifier)
				XCTAssertTrue(operation.rightTerm?.termTestIdentifier == one.termTestIdentifier)
				XCTAssertTrue(operation.basicOperator	== .addition)
				XCTAssertTrue(self.arithmetic.arithmeticValues.currentParentheticalExpression.low.basicOperator ==	.subtraction)
			case .addAfterMovingLastOperationWithValueToCurrentPrecedence:
				let _	  		: Void				=	self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _	 		: Void				=	self.arithmetic.evaluate(calculatorFunction: .pi)
				let pi			: TermProtocol		=	self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate!
				let _	 		: Void				=	self.arithmetic.evaluate(calculatorFunction: .addition)
				let _	 		: Void				=	self.arithmetic.evaluate(calculatorFunction: .openingParenthesis)
				let updateCase	: ArithmeticUpdate	=	.arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation, basicOperator: .addition)
				let _	 		: Void				=	self.arithmetic.evaluate(calculatorFunction: .addition)
				let lastTerm	: TermProtocol		=	self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded!
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(lastTerm.termTestIdentifier == pi.termTestIdentifier)
			case .addAfterPrecedencePromotion:
				let _	  		: Void				=	self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _	 		: Void				=	self.arithmetic.evaluate(calculatorFunction: .pi)
				let pi			: TermProtocol		=	self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate!
				let updateCase	: ArithmeticUpdate	=	.arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation, basicOperator: .multiplication)
				let _	 		: Void				=	self.arithmetic.evaluate(calculatorFunction: .multiplication)
				let highLeftTerm: TermProtocol		=	self.arithmetic.arithmeticValues.currentParentheticalExpression.high.leftTerm!

				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(highLeftTerm.termTestIdentifier == pi.termTestIdentifier)
				XCTAssertTrue(self.arithmetic.arithmeticValues.currentParentheticalExpression.high.basicOperator == .multiplication)
			case .addAfterPrecedenceDemotion:
				let _	  		: Void				=	self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _	 		: Void				=	self.arithmetic.evaluate(calculatorFunction: .pi)
				let pi			: TermProtocol		=	self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate!
				let _	 		: Void				=	self.arithmetic.evaluate(calculatorFunction: .multiplication)
				let updateCase	: ArithmeticUpdate	=	.arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation, basicOperator: .subtraction)
				let _	 		: Void				=	self.arithmetic.evaluate(calculatorFunction: .subtraction)
				let lowLeftTerm: TermProtocol		=	self.arithmetic.arithmeticValues.currentParentheticalExpression.low.leftTerm!

				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(lowLeftTerm.termTestIdentifier == pi.termTestIdentifier)
				XCTAssertTrue(self.arithmetic.arithmeticValues.currentParentheticalExpression.low.basicOperator == .subtraction)
			case .addAsPrecedenceOperator:
				let _	  		: Void				=	self.arithmetic.evaluate(calculatorFunction: .allClear)
				let updateCase	: ArithmeticUpdate	=	.arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation, basicOperator: .addition)
				let _	 		: Void				=	self.arithmetic.evaluate(calculatorFunction: .addition)
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(self.arithmetic.arithmeticValues.currentPrecedenceOperation.basicOperator == .addition)
			case .addAfterReplaceFunction2InputsWithInput1:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .pi)
				let pi			: DoubleNumber 		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate as! DoubleNumber
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation, basicOperator: .addition)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .addition)
				let lastTerm	: TermProtocol?		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
				
				XCTAssertTrue(updateCase == update)
				XCTAssertTrue(lastTerm?.termTestIdentifier	==	pi.termTestIdentifier)
				XCTAssertTrue(self.arithmetic.arithmeticValues.currentPrecedenceOperation.basicOperator == .addition)
			}
		}
		
	}
	
	func testCalculatorResult() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.CalculatorResultUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .addAsTermAfterResetingParentheticalExpressionContainersWith:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .addition)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .result)
				let term		: TermProtocol?		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue((term as? CalculatorResult)?.term.termType == .operation)
			case .continueLastTerm:
				let _			: Void 					= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 					= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 					= self.arithmetic.evaluate(calculatorFunction: .addition)
				let _			: Void 					= self.arithmetic.evaluate(calculatorFunction: .two)
				let _			: Void 					= self.arithmetic.evaluate(calculatorFunction: .result)
				let term		: TermProtocol?			= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
				let doubleValue	: Double?				= term?.doubleValue
				let updateCase	: ArithmeticUpdate 		= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 					= self.arithmetic.evaluate(calculatorFunction: .result)
				let operation	: PrecedenceOperation	= (term as! CalculatorResult).term as! PrecedenceOperation
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(operation.leftTerm?.doubleValue == doubleValue)
				XCTAssertTrue(operation.basicOperator == .addition)
				XCTAssertTrue(operation.rightTerm?.doubleValue == 2)
			}
		}
	}
	
	func testClearAllEntries() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.ClearAllEntriesUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .resetParentheticalExpressionContainerWithStartingTermZero:
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let lastTerm	: TermProtocol? = self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
			
				XCTAssert((lastTerm as? MutableNumber)?.doubleValue == 0)
				XCTAssertTrue(self.arithmetic.displayTerm.termTestIdentifier == lastTerm?.termTestIdentifier)
			}
		}
	}
	
	func testClosingParenthesis() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.ClosingParenthesisUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .closeInput2ParentheticalExpressionContainerEmpty:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .openingParenthesis)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .openingParenthesis)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .closingParenthesis)
				let updateCase	: ArithmeticUpdate	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .closingParenthesis)
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue((self.termToUpdate as? FunctionTwoInputs)?.input2 == nil)
			case .closeInput2ParentheticalExpressionContainerWithValue:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .openingParenthesis)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let updateCase	: ArithmeticUpdate	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				self.arithmetic.evaluate(calculatorFunction: .closingParenthesis)
				XCTAssertTrue(update == updateCase)
				
				XCTAssertTrue(self.termToUpdate?.termType == .functionTwoInputs)
				XCTAssertTrue((self.termToUpdate as! FunctionTwoInputs).input2?.doubleValue == 2)
			case .closeParentheticalExpressionEmpty:
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .two)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .addition)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .openingParenthesis)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .closingParenthesis)

				XCTAssertTrue(self.arithmetic.arithmeticValues.parentheticalExpressionContainers.last?.parentheticalExpressions.count == 1)
			case .closeParentheticalExpressionWithValue:
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .two)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .addition)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .openingParenthesis)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .three)

				let update = ArithmeticUpdate.arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				XCTAssertTrue(update == .closeParentheticalExpressionWithValue)
				let parentheticalExpressionDoubleValue = self.arithmetic.arithmeticValues.lastParentheticalExpressionContainerWithValue.parentheticalExpressions.last?.doubleValue
				self.arithmetic.evaluate(calculatorFunction: .closingParenthesis)

				XCTAssertTrue(self.termToUpdate?.doubleValue == parentheticalExpressionDoubleValue)
			case .preview:
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .two)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .addition)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .openingParenthesis)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .three)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .addition)
				
				let update = ArithmeticUpdate.arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				XCTAssertTrue(update == .preview)
				
				self.arithmetic.evaluate(calculatorFunction: .closingParenthesis)
				
				XCTAssertTrue(self.arithmetic.displayTerm.doubleValue == 6)
			case .doNothing:
				let _	: Void 			= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _	: Void 			= self.arithmetic.evaluate(calculatorFunction: .one)
				let one	: TermProtocol? = self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate
				let _	: Void 			= self.arithmetic.evaluate(calculatorFunction: .addition)
				let two	: TermProtocol? = self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate

				let update = ArithmeticUpdate.arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				XCTAssertTrue(update == .doNothing)
				self.arithmetic.evaluate(calculatorFunction: .closingParenthesis)

				let precedenceOperation = self.arithmetic.arithmeticValues.currentPrecedenceOperation

				XCTAssertTrue(precedenceOperation.leftTerm?.termTestIdentifier == one?.termTestIdentifier)
				XCTAssertTrue(precedenceOperation.rightTerm?.termTestIdentifier == two?.termTestIdentifier)
			}
		}
	}
	
	func testConstant() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.ConstantUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .addAsTerm:
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .addition)
				let updateCase	: ArithmeticUpdate	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .pi)
				let termToUpdate: TermProtocol?		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue((termToUpdate as? DoubleNumber)?.source.constant == .pi)
			case .replaceLastTerm:
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .one)
				let updateCase	: ArithmeticUpdate	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let one			: MutableNumber 	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate as! MutableNumber
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .eulersNumber)
				let doubleNumber: DoubleNumber 		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate as! DoubleNumber
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(doubleNumber.termTestIdentifier != one.termTestIdentifier)
			case.addAsInput2:
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let updateCase	: ArithmeticUpdate	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .pi)
				let termToUpdate: TermProtocol?		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate
				let input2		: DoubleNumber		= (termToUpdate as! FunctionTwoInputs).input2 as! DoubleNumber
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(input2.source.constant == .pi)
			}
		}
	}

	func testDecimal() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.DecimalUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .addAsTerm:
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .addition)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .decimal)
				
				XCTAssertTrue(self.arithmetic.arithmeticValues.currentPrecedenceOperation.rightTerm?.termType == .mutableNumber)
				
				let mutableNumber = self.arithmetic.arithmeticValues.currentPrecedenceOperation.rightTerm as? MutableNumber
				XCTAssertTrue(mutableNumber != nil)
				
				XCTAssertTrue(mutableNumber?.decimalAdded == true)
			case .doNothing:
				let _	: Void 			= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _	: Void			= self.arithmetic.evaluate(calculatorFunction: .pi)
				let pi	: TermProtocol? = self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate
				
				let update = ArithmeticUpdate.arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				XCTAssertTrue(update == .doNothing)
				
				let _ = self.arithmetic.evaluate(calculatorFunction: .decimal)
				let termToUpdate = self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate

				XCTAssertTrue(termToUpdate?.termTestIdentifier == pi?.termTestIdentifier)
			case .replaceLastTerm:
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .addition)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .one)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .baseXPowerTwo)
				let _: Void = self.arithmetic.evaluate(calculatorFunction: .decimal)
				
				XCTAssertTrue(self.arithmetic.arithmeticValues.currentPrecedenceOperation.rightTerm?.termType == .mutableNumber)
				
				let mutableNumber = self.arithmetic.arithmeticValues.currentPrecedenceOperation.rightTerm as? MutableNumber
				XCTAssertTrue(mutableNumber != nil)
				
				XCTAssertTrue(mutableNumber?.decimalAdded == true)
			case .updateLastTerm:
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let lastTerm	: TermProtocol! = self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate
				let lastTermUUID: UUID			= lastTerm.termTestIdentifier
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .decimal)
				
				let termToUpdate = self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate
				let termToUpdateUUID = termToUpdate?.termTestIdentifier
				XCTAssertTrue(termToUpdateUUID == lastTermUUID)
				
				XCTAssertTrue((termToUpdate as! MutableNumber).decimalAdded == true)
			case .addAsInput2:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .decimal)
				let function	: FunctionTwoInputs = self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate as! FunctionTwoInputs
				let input2		: TermProtocol		= function.input2!
				
				XCTAssert(update == updateCase)
				XCTAssert((input2 as? MutableNumber)?.decimalAdded == true)
			case .updateInput2:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let two			: MutableNumber		= ((self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate) as! FunctionTwoInputs).input2 as! MutableNumber
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .decimal)
				let function	: FunctionTwoInputs = self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate as! FunctionTwoInputs
				let input2		: TermProtocol		= function.input2!
				
				XCTAssert(update == updateCase)
				XCTAssert(two.decimalAdded == true)
				XCTAssert(input2.termTestIdentifier == two.termTestIdentifier)
			}
		}
	}
	
	func testFunctionOneInput() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.FunctionOneInputUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .addWithInput1FromDisplayTermToDisplayTerm:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let term		: TermProtocol	 	= self.arithmetic.displayTerm
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .addition)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerThree)
				let displayTerm	: FunctionOneInput	= self.arithmetic.displayTerm as! FunctionOneInput
				
				XCTAssert(update == updateCase)
				XCTAssert(displayTerm.input1.termTestIdentifier == term.termTestIdentifier)
			case .addWithInput1FromLastTermToLastTerm:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let term		: TermProtocol	 	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate!
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerThree)
				let lastTerm	: FunctionOneInput	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate as! FunctionOneInput
				
				XCTAssert(update == updateCase)
				XCTAssert(lastTerm.input1.termTestIdentifier == term.termTestIdentifier)
			}
		}
	}
	
	func testFunctionWithTwoInputs() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.FunctionTwoInputsUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .replaceFunctionTwoInputsKeepingInput1:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let two			: TermProtocol	 	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate!
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .baseYPowerX)
				let lastTerm	: FunctionTwoInputs	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded! as! FunctionTwoInputs
				
				XCTAssert(update == updateCase)
				XCTAssert(lastTerm.function == .baseYPowerX)
				XCTAssert(lastTerm.input1.termTestIdentifier == two.termTestIdentifier)
			case .addWithInput1FromLastTerm:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let two			: TermProtocol	 	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate!
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .baseYPowerX)
				let lastTerm	: FunctionTwoInputs	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded! as! FunctionTwoInputs
				
				XCTAssert(update == updateCase)
				XCTAssert(two.termTestIdentifier == lastTerm.input1.termTestIdentifier)
			case .addWithInput1FromLastTermAfterMovingLastOperationWithValueToCurrentPrecedence:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let two			: TermProtocol	 	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate!
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .addition)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .openingParenthesis)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .openingParenthesis)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .baseYPowerX)
				let lastTerm	: FunctionTwoInputs	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded! as! FunctionTwoInputs
				
				XCTAssert(update == updateCase)
				XCTAssert(lastTerm.function == .baseYPowerX)
				XCTAssert(lastTerm.input1.termTestIdentifier == two.termTestIdentifier)
			}
		}
	}
	
	func testMemoryRecall() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.MemoryRecallUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .addAsTerm:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .memoryRecall)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: .memoryRecall)
				let lastTerm	: TermProtocol? 	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue((lastTerm as? MemoryRecall)?.doubleValue == self.arithmetic.arithmeticValues.memoryRecall.doubleValue)
			case .addDisplayNumberDoubleValue:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .three)
				let doubleValue	: Double?			= self.arithmetic.displayTerm.doubleValue
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .memoryClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .memoryPlus)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: .memoryPlus)
				let memoryRecall: MemoryRecall	 	= self.arithmetic.arithmeticValues.memoryRecall
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(memoryRecall.doubleValue == doubleValue)
			case .reset:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .memoryClear)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: .memoryClear)
				let memoryRecall: MemoryRecall	 	= self.arithmetic.arithmeticValues.memoryRecall
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(memoryRecall.doubleValue == 0)
			case .subtractDisplayNumberDoubleValue:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .three)
				let doubleValue	: Double			= self.arithmetic.displayTerm.doubleValue!
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .memoryClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .memoryMinus)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: .memoryMinus)
				let memoryRecall: MemoryRecall	 	= self.arithmetic.arithmeticValues.memoryRecall
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(memoryRecall.doubleValue == (doubleValue * -1))
			case .addAsInput2:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerTwo)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: .memoryRecall)
				let function	: FunctionTwoInputs = self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate as! FunctionTwoInputs
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(function.input2?.termType == .memoryRecall)
			}
		}
	}

	func testMutableNumber() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.MutableNumberUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .addAsTerm:
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .addition)
				let updateCase		: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let lastTerm		: TermProtocol		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded!

				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(lastTerm.termType == .mutableNumber)
			case .doNothing:
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .pi)
				let pi				: TermProtocol		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded!
				let updateCase		: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let lastTerm		: TermProtocol		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded!

				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(lastTerm.termTestIdentifier == pi.termTestIdentifier)
			case .replaceLastTerm:
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerTwo)
				let updateCase		: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let lastTerm		: TermProtocol		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded!

				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(lastTerm.termType == .mutableNumber)
			case .updateLastTerm:
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let mutableNumber	: MutableNumber		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate as! MutableNumber
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let updateCase		: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _				: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let lastTerm		: TermProtocol		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded!

				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(mutableNumber.termTestIdentifier == lastTerm.termTestIdentifier)
			case .updateInput2:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let term		: TermProtocol? 	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(((term as? FunctionTwoInputs)?.input2 as? MutableNumber)?.doubleValue == 11)
			case .replaceInput2:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let term		: TermProtocol?		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(((term as? FunctionTwoInputs)?.input2 as? MutableNumber)?.doubleValue == 1)
			}
		}
	}
	
	func testNegateNumberSign() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.NegateNumberSignUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .addAsTerm:
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .addition)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .signChange)
				let term		: TermProtocol? = self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue((term as? MutableNumber)?.negateNumber == true)
			case .updateLastTerm:
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .one)
				let one			: TermProtocol? = self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .signChange)
				let term		: TermProtocol? = self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue((one as? MutableNumber)?.termTestIdentifier == term?.termTestIdentifier)
				XCTAssertTrue((one as? MutableNumber)?.negateNumber == true)
			case .addAsInput2:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .signChange)
				let input2		: MutableNumber		= (self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded as! FunctionTwoInputs).input2 as! MutableNumber
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(input2.negateNumber == true)
			case .updateInput2:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let one			: MutableNumber		= (self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded as! FunctionTwoInputs).input2 as! MutableNumber
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .signChange)
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(one.negateNumber == true)
			}
		}
	}
	
	func testOpeningParenthesis() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.OpeningParenthesisUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .addAsParentheticalExpressionContainerForInput2WithInput2AsStartingTerm:
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .one)
				let one			: MutableNumber	= (self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded as! FunctionTwoInputs).input2 as! MutableNumber
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .openingParenthesis)
				let movedOne	: MutableNumber	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded as! MutableNumber
				
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue(arithmetic.arithmeticValues.parentheticalExpressionContainers.last?.reverseFunctionTwoInputs != nil)
				XCTAssert(one.termTestIdentifier == movedOne.termTestIdentifier)
			case .addAsParentheticalExpressionWithLastTermAsStartingTerm:
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .one)
				let one	: MutableNumber	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded as! MutableNumber
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 			= self.arithmetic.evaluate(calculatorFunction: .openingParenthesis)
				let movedOne	: MutableNumber	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded as! MutableNumber
				
				XCTAssertTrue(update == updateCase)
				XCTAssert(one.termTestIdentifier == movedOne.termTestIdentifier)
			}
		}
	}
	
	func testPercentageFunction() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.PercentageFunctionUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .replaceDisplayTermUsingDisplayTermPercentOf100:
				let _					: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _					: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _					: Void 				= self.arithmetic.evaluate(calculatorFunction: .addition)
				let percentDisplayTerm	: TermProtocol? 	= self.arithmetic.displayTerm
				let updateCase			: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _					: Void 				= self.arithmetic.evaluate(calculatorFunction: .percent)
				let displayTerm			: TermProtocol? 	= self.arithmetic.displayTerm
								
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue((displayTerm as? PercentageFunction)?.termPercent.termTestIdentifier == percentDisplayTerm?.termTestIdentifier)
			case .replaceInput2UsingInput2PercentOf100:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .percent)
				let term		: TermProtocol?		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
								
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue((term as? FunctionTwoInputs)?.input2?.termType == .percentageFunction)
			case .replaceLastTermUsingLastTermPercentOf100:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let one			: TermProtocol? 	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .percent)
				let term		: TermProtocol?		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
								
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue((term as? PercentageFunction)?.termPercent.termTestIdentifier == one?.termTestIdentifier)
			case  .replaceLastTermUsingRightTermPercentOfLeftTerm:
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .one)
				let one			: TermProtocol? 	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .addition)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .two)
				let two			: TermProtocol? 	= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
				let updateCase	: ArithmeticUpdate 	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void 				= self.arithmetic.evaluate(calculatorFunction: .percent)
				let term		: TermProtocol?		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.lastTermAdded
								
				XCTAssertTrue(update == updateCase)
				XCTAssertTrue((term as? PercentageFunction)?.termOf.termTestIdentifier == one?.termTestIdentifier)
				XCTAssertTrue((term as? PercentageFunction)?.termPercent.termTestIdentifier == two?.termTestIdentifier)
			}
		}
	}
	
	func testSIUnit() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.SIUnitUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .updateSIUnit:
				let lastSIUnit	: CalculatorFunction	= self.arithmetic.arithmeticValues.siUnit
				let nextSIUnit	: CalculatorFunction 	= lastSIUnit == .degrees ? .radians : .degrees
				let _			: Void					= self.arithmetic.evaluate(calculatorFunction: nextSIUnit)
				
				XCTAssertTrue(self.arithmetic.arithmeticValues.siUnit == nextSIUnit)
			}
		}
	}
	
	func testShowSecondFunctions() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.ShowSecondFunctionsUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .doNothing:
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .baseXPowerY)
				let term		: TermProtocol?		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate
				let updateCase	: ArithmeticUpdate	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentFunctionWithTwoInputs)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .secondFunction)
				
				XCTAssertTrue(updateCase == update)
				XCTAssertTrue(self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate?.termTestIdentifier == term?.termTestIdentifier)
			case .replaceLastTermWithInput1:
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .pi)
				let pi			: TermProtocol?		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .baseYPowerX)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .openingParenthesis)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .addition)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .one)
				let updateCase	: ArithmeticUpdate	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentFunctionWithTwoInputs)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .secondFunction)
				
				XCTAssertTrue(updateCase == update)
				XCTAssertTrue(pi?.termTestIdentifier ==	self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate?.termTestIdentifier)
			}
		}
	}
	
	func testTrigonometricFunction() {
		typealias ArithmeticUpdate = CalculatorArithmetic.ArithmeticUpdate.TrigonometricFunctionUpdate
		
		for update in ArithmeticUpdate.all {
			switch update {
			case .addWithInput1FromDisplayTermToDisplayTerm:
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .one)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .addition)
				let term		: TermProtocol?		= self.arithmetic.displayTerm
				let updateCase	: ArithmeticUpdate	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .rightAngleSine)
				let displayTerm	: TermProtocol?		= self.arithmetic.displayTerm
				
				XCTAssertTrue(updateCase == update)
				XCTAssertTrue((displayTerm as? TrigonometricFunction)?.input1.termTestIdentifier == term?.termTestIdentifier)
			case .addWithInput1FromLastTermToLastTerm:
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .allClear)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .one)
				let one		: TermProtocol?		= self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate
				let updateCase	: ArithmeticUpdate	= .arithmeticUpdate(for: self.arithmetic.arithmeticValues.currentPrecedenceOperation)
				let _			: Void				= self.arithmetic.evaluate(calculatorFunction: .rightAngleSine)
				
				XCTAssertTrue(updateCase == update)
				XCTAssertTrue((self.arithmetic.arithmeticValues.currentPrecedenceOperation.termToUpdate as? TrigonometricFunction)?.input1.termTestIdentifier == one?.termTestIdentifier)
			}
		}
	}
	
	func testDoubleValues() {
		let arithmetic = CalculatorArithmetic()
		arithmetic.arithmeticValues.currentPrecedenceOperation.add(newTerm: DoubleNumber(doubleValue: 12345))
		
		let operationDoubleValue = arithmetic.arithmeticValues.currentPrecedenceOperation.doubleValue
		let parentheticalDoubleValue = arithmetic.arithmeticValues.currentPrecedenceOperation.reverseParentheticalExpression?.doubleValue
		let parentheticalContainerDoubleValue = arithmetic.arithmeticValues.currentPrecedenceOperation.reverseParentheticalExpression?.reverseParentheticalExpressionContainer.doubleValue
		
		XCTAssertTrue(operationDoubleValue == parentheticalDoubleValue && parentheticalDoubleValue == parentheticalContainerDoubleValue)
	}
}

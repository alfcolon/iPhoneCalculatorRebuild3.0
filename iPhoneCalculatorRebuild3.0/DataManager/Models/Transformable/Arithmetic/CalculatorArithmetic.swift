//
//  CalculatorArithmetic.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

protocol DisplayTermUpdateProtocol {
    var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm { get }
}

public class CalculatorArithmetic: NSObject, NSSecureCoding {

    // MARK: - Models
    
    enum ArithmeticUpdate {
        enum DisplayTerm {
            case updateFromInput1FunctionOneInput
            case updateFromInput1FromFunctionTwoInputs
            case updateFromInput2
            case updateFromLastTerm
            case updateWithParentheticalExpressionTotal
            case updateWithPrecedenceOperationTotal
            case noUpdate
            case updatedDuringArithmeticUpdate
        }
        enum BasicOperatorUpdate: DisplayTermUpdateProtocol {
            case addAfterMovingLastOperationWithValueToCurrentPrecedence
            case addAfterPrecedencePromotion
            case addAfterPrecedenceDemotion
            case addAsPrecedenceOperator
            case addAfterRefactoringHighPrecedenceToLeftTermAsDoubleNumber
            case addAfterRefactoringLowPrecedenceToLeftTermAsOperation
            case addAfterReplaceFunction2InputsWithInput1
            //            case addLastTermWithValueToEmptyInput2
                        
            static var all: [BasicOperatorUpdate] = [
                .addAfterMovingLastOperationWithValueToCurrentPrecedence,
                .addAfterPrecedencePromotion,
                .addAfterPrecedenceDemotion,
                .addAsPrecedenceOperator,
                .addAfterRefactoringHighPrecedenceToLeftTermAsDoubleNumber,
                .addAfterRefactoringLowPrecedenceToLeftTermAsOperation,
                .addAfterReplaceFunction2InputsWithInput1
            ]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation, basicOperator: CalculatorFunction) -> BasicOperatorUpdate {
                let termToUpdate = precedenceOperation.termToUpdate
                let input2IsEmptyParentheticalExpressionContainer: Bool = {
                    guard (precedenceOperation.reverseTerm as? ParentheticalExpression)?.reverseParentheticalExpressionContainer?.reverseFunctionTwoInputs != nil else { return false }
                    guard (precedenceOperation.reverseTerm as? ParentheticalExpression)!.reverseParentheticalExpressionContainer.isEmpty else { return false }
                    return true
                }()
                let input2IsEmpty: Bool = termToUpdate?.termType == .functionTwoInputs && (termToUpdate as? FunctionTwoInputs)?.input2 == nil
                let parentheticalExpressionIsEmpty: Bool = (precedenceOperation.reverseTerm as? ParentheticalExpression)!.isEmpty
                
                switch true {
                case input2IsEmpty || input2IsEmptyParentheticalExpressionContainer:
                    return .addAfterReplaceFunction2InputsWithInput1
                case parentheticalExpressionIsEmpty:
                    return .addAfterMovingLastOperationWithValueToCurrentPrecedence
                case (precedenceOperation.reverseTerm as? ParentheticalExpression)?.currentPrecedence == .high:
                    switch true {
                    case basicOperator == .addition || basicOperator == .subtraction:
                        return .addAfterPrecedenceDemotion
                    case precedenceOperation.rightTerm != nil:
                        return .addAfterRefactoringHighPrecedenceToLeftTermAsDoubleNumber
                    default:
                        return .addAsPrecedenceOperator
                    }
                case (precedenceOperation.reverseTerm as? ParentheticalExpression)?.currentPrecedence == .low:
                    switch true {
                    case basicOperator == .multiplication || basicOperator == .division:
                        return .addAfterPrecedencePromotion
                    case precedenceOperation.rightTerm != nil:
                        return .addAfterRefactoringLowPrecedenceToLeftTermAsOperation
                    default:
                        return .addAsPrecedenceOperator
                    }
                default:
                    return .addAsPrecedenceOperator
                }
            }
            
            // MARK: - Display Term Protocol

            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                return .updateFromLastTerm
            }
        }
        enum CalculatorResultUpdate: DisplayTermUpdateProtocol {
            case addAsTermAfterResetingParentheticalExpressionContainersWith
            case continueLastTerm
            
            static var all: [CalculatorResultUpdate] = [
                .addAsTermAfterResetingParentheticalExpressionContainersWith,
                .continueLastTerm
            ]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> CalculatorResultUpdate {
                switch true {
                case precedenceOperation.termToUpdate?.termType == .calculatorResult:
                    return .continueLastTerm
                default:
                    return .addAsTermAfterResetingParentheticalExpressionContainersWith
                }
            }
            
            // MARK: - Display Term Protocol

            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                return .updateFromLastTerm
            }
        }
        enum ClearAllEntriesUpdate: DisplayTermUpdateProtocol {
            case resetParentheticalExpressionContainerWithStartingTermZero
            
            static var all: [ClearAllEntriesUpdate] = [.resetParentheticalExpressionContainerWithStartingTermZero]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> ClearAllEntriesUpdate {
                return .resetParentheticalExpressionContainerWithStartingTermZero
            }
            
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                switch self {
                case .resetParentheticalExpressionContainerWithStartingTermZero:
                    return .updateFromLastTerm
                }
            }
        }
        enum ClosingParenthesisUpdate: DisplayTermUpdateProtocol {
            case closeParentheticalExpressionWithValue
            case closeParentheticalExpressionEmpty
            case closeInput2ParentheticalExpressionContainerEmpty
            case closeInput2ParentheticalExpressionContainerWithValue
            case preview
            case doNothing
            
            static var all: [ClosingParenthesisUpdate] = [
                .closeParentheticalExpressionWithValue,
                .closeParentheticalExpressionEmpty,
                .closeInput2ParentheticalExpressionContainerEmpty,
                .closeInput2ParentheticalExpressionContainerWithValue,
                .preview,
                .doNothing
            ]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> ClosingParenthesisUpdate {
                let isInput2 = (precedenceOperation.reverseTerm as? ParentheticalExpression)?.reverseParentheticalExpressionContainer.reverseFunctionTwoInputs != nil
                let input2IsEmpty = ((precedenceOperation.reverseTerm as? ParentheticalExpression)?.reverseParentheticalExpressionContainer.isEmpty)! && (precedenceOperation.reverseTerm as? ParentheticalExpression)?.reverseParentheticalExpressionContainer.parentheticalExpressions.count == 1
                let parentheticalExpression: Bool = isInput2 == false
                let parentheticalExpressionIsEmpty: Bool = precedenceOperation.isEmpty
                let noAddedParentheticalExpressions: Bool = {
                    guard (precedenceOperation.reverseTerm as? ParentheticalExpression)?.reverseParentheticalExpressionContainer.reverseFunctionTwoInputs == nil else { return false }
                    return (precedenceOperation.reverseTerm as? ParentheticalExpression)?.reverseParentheticalExpressionContainer.parentheticalExpressions.count == 1
                }()
                
                switch true {
                case noAddedParentheticalExpressions:
                    return .doNothing
                case (isInput2 && input2IsEmpty):
                    return .closeInput2ParentheticalExpressionContainerEmpty
                case parentheticalExpressionIsEmpty:
                    return .closeParentheticalExpressionEmpty
                case (isInput2 && input2IsEmpty == false):
                    if parentheticalExpressionIsEmpty {
                        return .closeParentheticalExpressionEmpty
                    } else if precedenceOperation.numberValueNeeded {
                        return .preview
                    }
                    return .closeInput2ParentheticalExpressionContainerWithValue
                case (parentheticalExpression && parentheticalExpressionIsEmpty):
                    return .closeParentheticalExpressionEmpty
                case (parentheticalExpression && parentheticalExpressionIsEmpty == false):
                    return precedenceOperation.numberValueNeeded ? .preview : .closeParentheticalExpressionWithValue
                default:
                    fatalError()
                }
            }
                
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                switch self {
                case .closeParentheticalExpressionWithValue:
                    return .updateFromLastTerm
                case .closeInput2ParentheticalExpressionContainerWithValue:
                    return .updateFromInput2
                case .preview:
                    return .updatedDuringArithmeticUpdate
                default:
                    return .noUpdate
                }
            }
        }
        enum ConstantUpdate: DisplayTermUpdateProtocol {
            case addAsTerm
            case replaceLastTerm
            case addAsInput2
            
            static var all: [ConstantUpdate] = [
                .addAsTerm,
                .replaceLastTerm,
                .addAsInput2
            ]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> ConstantUpdate {
                switch precedenceOperation.termToUpdate?.termType {
                case .functionTwoInputs:
                    return .addAsInput2
                case .none:
                    return .addAsTerm
                default:
                    return .replaceLastTerm
                }
            }
            
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                return self == .addAsInput2 ? .updateFromInput2 : .updateFromLastTerm
            }
        }
        enum DecimalUpdate: DisplayTermUpdateProtocol {
            case addAsTerm
            case replaceLastTerm
            case updateLastTerm
            case doNothing
            case addAsInput2
            case updateInput2
            
            static var all: [DecimalUpdate] = [
                .addAsTerm,
                .replaceLastTerm,
                .updateLastTerm,
                .doNothing,
                .addAsInput2,
                .updateInput2
                
            ]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> DecimalUpdate {
                let termToUpdate = precedenceOperation.termToUpdate
                switch precedenceOperation.termToUpdate?.termType {
                case .none:
                    return .addAsTerm
                case .functionTwoInputs:
                    switch (precedenceOperation.termToUpdate as? FunctionTwoInputs)?.input2?.termType {
                    case .double:
                        guard ((precedenceOperation.termToUpdate as? FunctionTwoInputs)?.input2 as? DoubleNumber)?.source.constant == nil else { return .doNothing }
                        fallthrough
                    case .mutableNumber:
                        return .updateInput2
                    default:
                        return .addAsInput2
                    }
                case .mutableNumber:
                    return .updateLastTerm
                case .double:
                    switch (termToUpdate as? DoubleNumber)?.source {
                    case .constant:
                        return .doNothing
                    default:
                        break
                    }
                    fallthrough
                default:
                    return .replaceLastTerm
                }
            }
            
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                return (self == .updateInput2 || self == .addAsInput2) ? .updateFromInput2 : .updateFromLastTerm
            }
        }
        enum MutableNumberUpdate: DisplayTermUpdateProtocol {
            case addAsTerm
            case replaceLastTerm
            case updateLastTerm
            case doNothing
            case replaceInput2
            case updateInput2
            
            static var all: [MutableNumberUpdate] = [
                .addAsTerm,
                .replaceLastTerm,
                .updateLastTerm,
                .doNothing
            ]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> MutableNumberUpdate {
                switch precedenceOperation.termToUpdate?.termType {
                case .none:
                    return .addAsTerm
                case .double:
                    let doubleNumber = precedenceOperation.termToUpdate as! DoubleNumber
                    return doubleNumber.source.constant == nil ? .replaceLastTerm : .doNothing
                case .mutableNumber:
                    return .updateLastTerm
                case .constantNumber:
                    return .doNothing
                case .functionTwoInputs:
                    switch (precedenceOperation.termToUpdate as? FunctionTwoInputs)?.input2?.termType {
                    case .double:
                        guard ((precedenceOperation.termToUpdate as? FunctionTwoInputs)?.input2 as? DoubleNumber)?.source.constant == nil else { return .doNothing }
                        fallthrough
                    case .mutableNumber:
                        return .updateInput2
                    default:
                        return .replaceInput2
                    }
                default:
                    return .replaceLastTerm
                }
            }
            
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                switch self {
                case .doNothing:
                    return .noUpdate
                case .replaceInput2, .updateInput2:
                    return .updateFromInput2
                default:
                    return .updateFromLastTerm
                }
            }
        }
        enum FunctionOneInputUpdate: DisplayTermUpdateProtocol {
            case addWithInput1FromDisplayTermToDisplayTerm
            case addWithInput1FromLastTermToLastTerm
            
            static var all: [FunctionOneInputUpdate] = [
                .addWithInput1FromDisplayTermToDisplayTerm,
                .addWithInput1FromLastTermToLastTerm
            ]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> FunctionOneInputUpdate {
                switch precedenceOperation.termToUpdate?.termType {
                case .none:
                    return .addWithInput1FromDisplayTermToDisplayTerm
                default:
                    return .addWithInput1FromLastTermToLastTerm
                }
            }
            
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                switch self {
                case .addWithInput1FromLastTermToLastTerm:
                    return .updateFromLastTerm
                default:
                    return .updatedDuringArithmeticUpdate
                }
            }
        }
        enum FunctionTwoInputsUpdate: DisplayTermUpdateProtocol {
            case addWithInput1FromLastTermAfterMovingLastOperationWithValueToCurrentPrecedence
            case addWithInput1FromLastTerm
            case replaceFunctionTwoInputsKeepingInput1
            
            static var all: [FunctionTwoInputsUpdate] = [
                .addWithInput1FromLastTermAfterMovingLastOperationWithValueToCurrentPrecedence,
                .addWithInput1FromLastTerm,
                .replaceFunctionTwoInputsKeepingInput1
            ]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> FunctionTwoInputsUpdate {
                let termToUpdate = precedenceOperation.termToUpdate
                let input2IsEmpty = termToUpdate?.termType == .functionTwoInputs && (termToUpdate as? FunctionTwoInputs)?.input2 == nil
                let input2IsEmptyParentheticalExpressionContainer: Bool = {
                    guard (precedenceOperation.reverseTerm as? ParentheticalExpression)?.reverseParentheticalExpressionContainer?.reverseFunctionTwoInputs != nil else { return false }
                    guard (precedenceOperation.reverseTerm as? ParentheticalExpression)!.reverseParentheticalExpressionContainer.isEmpty else { return false }
                    return true
                }()

                switch true {
                case (input2IsEmpty || input2IsEmptyParentheticalExpressionContainer):
                    return .replaceFunctionTwoInputsKeepingInput1
                case precedenceOperation.reverseTerm != nil && (precedenceOperation.reverseTerm as? ParentheticalExpression)!.isEmpty:
                    return .addWithInput1FromLastTermAfterMovingLastOperationWithValueToCurrentPrecedence
                case termToUpdate != nil:
                    return .addWithInput1FromLastTerm
                default:
                    fatalError()
                }
            }
            
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                switch self {
                case .addWithInput1FromLastTermAfterMovingLastOperationWithValueToCurrentPrecedence:
                    return .updateFromInput1FromFunctionTwoInputs
                default:
                    return .noUpdate
                }
            }
        }
        enum MemoryRecallUpdate: DisplayTermUpdateProtocol {
            case addAsTerm
            case addDisplayNumberDoubleValue
            case subtractDisplayNumberDoubleValue
            case reset
            case addAsInput2
            
            static var all: [MemoryRecallUpdate] = [
                .addAsTerm,
                .addDisplayNumberDoubleValue,
                .subtractDisplayNumberDoubleValue,
                .reset
            ]
            
            static func arithmeticUpdate(for memoryFunction: CalculatorFunction) -> MemoryRecallUpdate {
                switch memoryFunction {
                case .memoryPlus:
                    return .addDisplayNumberDoubleValue
                case .memoryMinus:
                    return .subtractDisplayNumberDoubleValue
                case .memoryClear:
                    return .reset
                case .memoryRecall:
                    return .addAsTerm
                default:
                    fatalError()
                }
            }
            
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                switch self {
                case .addAsTerm:
                    return .updateFromLastTerm
                case .addAsInput2:
                    return .updateFromInput2
                default:
                    return .noUpdate
                }
            }
        }
        enum PercentageFunctionUpdate: DisplayTermUpdateProtocol {
            case replaceInput2UsingInput2PercentOf100
            case replaceLastTermUsingLastTermPercentOf100
            case replaceLastTermUsingRightTermPercentOfLeftTerm
            case replaceDisplayTermUsingDisplayTermPercentOf100
            
            /*
                logical ehh's:
                    - Pulling from numbers preceding an open paranthesis
                        - 5 + (5 = 0.25
                        - This is actually impossible because "(5" is an undefined number
                    - Using last operators to update precedence and parenthetical term's value
                        - 5 + 5 + % = .5
                        - this is also impossible because 5 + 5 + displays its parenthetical total of 10
                    
            */
            static var all: [PercentageFunctionUpdate] = [
                .replaceInput2UsingInput2PercentOf100,
                .replaceLastTermUsingLastTermPercentOf100,
                .replaceLastTermUsingRightTermPercentOfLeftTerm,
                .replaceDisplayTermUsingDisplayTermPercentOf100
            ]
            
            /*
                input2 - always update using input2 term
                operation(add/subtract) - always rightTermPercent of leftTerm
                operation(multiple/divide) - always last term percentf of 100
                displayTerm = always use displayTermPercentOf100
            */
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> PercentageFunctionUpdate {
                let termToUpdate = precedenceOperation.termToUpdate
                
                switch true {
                case termToUpdate?.termType == .functionTwoInputs && (termToUpdate as? FunctionTwoInputs)?.input2 != nil:
                    return .replaceInput2UsingInput2PercentOf100
                case termToUpdate == nil:
                    return .replaceDisplayTermUsingDisplayTermPercentOf100
                case precedenceOperation.basicOperator == .addition || precedenceOperation.basicOperator == .subtraction:
                    return .replaceLastTermUsingRightTermPercentOfLeftTerm
                default:
                    return .replaceLastTermUsingLastTermPercentOf100
                }
            }
            
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                switch self {
                case .replaceInput2UsingInput2PercentOf100:
                    return .updateFromInput2
                case .replaceLastTermUsingLastTermPercentOf100, .replaceLastTermUsingRightTermPercentOfLeftTerm:
                    return .updateFromLastTerm
                case .replaceDisplayTermUsingDisplayTermPercentOf100:
                    return .updatedDuringArithmeticUpdate
                }
            }
        }
        enum OpeningParenthesisUpdate: DisplayTermUpdateProtocol {
            case addAsParentheticalExpressionContainerForInput2WithInput2AsStartingTerm
            case addAsParentheticalExpressionWithLastTermAsStartingTerm
            
            static var all: [OpeningParenthesisUpdate] = [
                .addAsParentheticalExpressionContainerForInput2WithInput2AsStartingTerm,
                .addAsParentheticalExpressionWithLastTermAsStartingTerm,
            ]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> OpeningParenthesisUpdate {
                switch true {
                case precedenceOperation.termToUpdate?.termType == .functionTwoInputs:
                    return .addAsParentheticalExpressionContainerForInput2WithInput2AsStartingTerm
                default:
                    return .addAsParentheticalExpressionWithLastTermAsStartingTerm
                }
            }
            
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                return .noUpdate
            }
        }
        enum NegateNumberSignUpdate: DisplayTermUpdateProtocol {
            case updateLastTerm
            case addAsTerm
            case addAsInput2
            case updateInput2
            
            static var all: [NegateNumberSignUpdate] = [
                .updateLastTerm,
                .addAsTerm
            ]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> NegateNumberSignUpdate {
                switch precedenceOperation.termToUpdate?.termType {
                case .none:
                    return .addAsTerm
                case .functionTwoInputs:
                    return (precedenceOperation.termToUpdate as? FunctionTwoInputs)?.input2 != nil ? .updateInput2 : .addAsInput2
                default:
                    return .updateLastTerm
                }
            }

            // MARK: - Display Term Protocol

            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                return (self == .addAsInput2 || self == .updateInput2) ? .updateFromInput2 : .updateFromLastTerm
            }
        }
        enum ShowSecondFunctionsUpdate: DisplayTermUpdateProtocol {
            case replaceLastTermWithInput1
            case doNothing
            
            static var all: [ShowSecondFunctionsUpdate] = [
                .replaceLastTermWithInput1,
                .doNothing
            ]
            
            static func arithmeticUpdate(for currentFunctionWithTwoInputs: FunctionTwoInputs?) -> ShowSecondFunctionsUpdate {
                return currentFunctionWithTwoInputs?.function == .baseYPowerX ? .replaceLastTermWithInput1 : .doNothing
            }
            
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                return self == .doNothing ? .noUpdate : .updateFromLastTerm
            }
        }
        enum SIUnitUpdate: DisplayTermUpdateProtocol {
            case updateSIUnit
            
            static var all: [SIUnitUpdate] = [
                .updateSIUnit
            ]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> SIUnitUpdate {
                return .updateSIUnit
            }
            
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                return .noUpdate
            }
        }
        enum TrigonometricFunctionUpdate: DisplayTermUpdateProtocol {
            case addWithInput1FromDisplayTermToDisplayTerm
            case addWithInput1FromLastTermToLastTerm
            
            static var all: [TrigonometricFunctionUpdate] = [
                .addWithInput1FromDisplayTermToDisplayTerm,
                .addWithInput1FromLastTermToLastTerm
            ]
            
            static func arithmeticUpdate(for precedenceOperation: PrecedenceOperation) -> TrigonometricFunctionUpdate {
                switch precedenceOperation.termToUpdate?.termType {
                case .none:
                    return .addWithInput1FromDisplayTermToDisplayTerm
                default:
                    return .addWithInput1FromLastTermToLastTerm
                }
            }
            
            // MARK: - Display Term Protocol
            
            var displayTermUpdate: CalculatorArithmetic.ArithmeticUpdate.DisplayTerm {
                return self == .addWithInput1FromLastTermToLastTerm ? .updateFromLastTerm : .noUpdate
            }
        }
    }

    class ArithmeticValues {
        
        // MARK: - Properties
        
        var memoryRecall: MemoryRecall
        var parentheticalExpressionContainers: [ParentheticalExpressionContainer]
        var siUnit: CalculatorFunction
        
        // MARK: - Init
        
        init(startingTerm: TermProtocol) {
            self.memoryRecall = .init(doubleValue: 0)
            self.parentheticalExpressionContainers = []
            self.parentheticalExpressionContainers.append(.init(reverseFunctionTwoInputs: nil, startingTerm: MutableNumber(digit: .zero)))
            self.siUnit = .degrees
        }
        
        init(memoryRecall: TermProtocol, parentheticalExpressonContainers: [ParentheticalExpressionContainer], siUnit: CalculatorFunction) {
            self.memoryRecall = memoryRecall as! MemoryRecall
            self.parentheticalExpressionContainers = parentheticalExpressonContainers
            self.siUnit = siUnit
        }

        // MARK: - Info
        
        var lastParentheticalExpressionContainerWithValue: ParentheticalExpressionContainer {
            var index = self.parentheticalExpressionContainers.count - 1
            
            while index >= 0 {
                if self.parentheticalExpressionContainers[index].isEmpty == false {
                    return self.parentheticalExpressionContainers[index]
                }
                index -= 1
            }
            fatalError()
        }
        var currentPrecedenceOperation: PrecedenceOperation {
            return self.parentheticalExpressionContainers.last!.parentheticalExpressions.last!.currentPrecedenceOperation
        }
        var currentParentheticalExpression: ParentheticalExpression {
            return self.parentheticalExpressionContainers.last!.parentheticalExpressions.last!
        }
        var currentFunctionWithTwoInputs: FunctionTwoInputs? {
            guard self.parentheticalExpressionContainers.last!.reverseFunctionTwoInputs == nil else { return self.parentheticalExpressionContainers.last!.reverseFunctionTwoInputs }
            return self.currentPrecedenceOperation.termToUpdate as? FunctionTwoInputs
        }

        // MARK: - Methods
        
        func resetParentheticalExpressionContainers(startingTerm: TermProtocol) {
            self.parentheticalExpressionContainers = []
            let parentheticalExpressionContainer = ParentheticalExpressionContainer(reverseFunctionTwoInputs: nil, startingTerm: startingTerm)
            self.parentheticalExpressionContainers.append(parentheticalExpressionContainer)
        }
    }
    
    // MARK: - Properties

    let arithmeticValues: ArithmeticValues
    var displayTerm: TermProtocol

    // MARK: - init
    
    public override init() {
        let startingTerm = MutableNumber(digit: .zero)
        self.arithmeticValues = ArithmeticValues(startingTerm: startingTerm)
        self.displayTerm = startingTerm
    }
    
    // MARK: - Methods
    
    func evaluate(calculatorFunction: CalculatorFunction) {
        let container = self.arithmeticValues.parentheticalExpressionContainers
        let functionCategory: CalculatorFunction.FunctionCategory = .init(calculatorFunction: calculatorFunction)
        let termCategory: CalculatorFunction.TermCategory? = .init(calculatorFunction: calculatorFunction)
        
        switch true {
        case calculatorFunction == .allClear:
            let update: ArithmeticUpdate.ClearAllEntriesUpdate = ArithmeticUpdate.ClearAllEntriesUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update)
            self.process(update: update.displayTermUpdate)
        case calculatorFunction == .closingParenthesis:
            let update: ArithmeticUpdate.ClosingParenthesisUpdate = ArithmeticUpdate.ClosingParenthesisUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update)
            self.process(update: update.displayTermUpdate)
        case termCategory == .constant:
            let update: ArithmeticUpdate.ConstantUpdate = ArithmeticUpdate.ConstantUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update, constant: calculatorFunction)
            self.process(update: update.displayTermUpdate)
        case calculatorFunction == .decimal:
            let update: ArithmeticUpdate.DecimalUpdate = ArithmeticUpdate.DecimalUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update)
            self.process(update: update.displayTermUpdate)
        case functionCategory == .digit:
            let update: ArithmeticUpdate.MutableNumberUpdate = ArithmeticUpdate.MutableNumberUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update, digit: calculatorFunction)
            self.process(update: update.displayTermUpdate)
        case termCategory == .functionOneInput:
            let update: ArithmeticUpdate.FunctionOneInputUpdate = ArithmeticUpdate.FunctionOneInputUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update, function: calculatorFunction)
            self.process(update: update.displayTermUpdate)
        case termCategory == .functionTwoInputs:
            let update: ArithmeticUpdate.FunctionTwoInputsUpdate = ArithmeticUpdate.FunctionTwoInputsUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update, function: calculatorFunction)
            self.process(update: update.displayTermUpdate)
        case functionCategory == .memoryRecall:
            let update: ArithmeticUpdate.MemoryRecallUpdate = ArithmeticUpdate.MemoryRecallUpdate.arithmeticUpdate(for: calculatorFunction)
            
            self.process(update: update)
            self.process(update: update.displayTermUpdate)
        case calculatorFunction == .openingParenthesis:
            let update: ArithmeticUpdate.OpeningParenthesisUpdate = ArithmeticUpdate.OpeningParenthesisUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update)
            self.process(update: update.displayTermUpdate)
        case functionCategory == .basicOperator:
            let update: ArithmeticUpdate.BasicOperatorUpdate = ArithmeticUpdate.BasicOperatorUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation, basicOperator: calculatorFunction)
            
            self.process(update: update, basicOperator: calculatorFunction)
            self.process(update: update.displayTermUpdate)
        case calculatorFunction == .percent:
            let update: ArithmeticUpdate.PercentageFunctionUpdate = ArithmeticUpdate.PercentageFunctionUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update)
            self.process(update: update.displayTermUpdate)
        case calculatorFunction == .result:
            let update: ArithmeticUpdate.CalculatorResultUpdate = ArithmeticUpdate.CalculatorResultUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update)
            self.process(update: update.displayTermUpdate)
        case calculatorFunction == .signChange:
            let update: ArithmeticUpdate.NegateNumberSignUpdate = ArithmeticUpdate.NegateNumberSignUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update)
            self.process(update: update.displayTermUpdate)
        case functionCategory == .siUnit:
            let update: ArithmeticUpdate.SIUnitUpdate = ArithmeticUpdate.SIUnitUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update, siUnit: calculatorFunction)
            self.process(update: update.displayTermUpdate)
        case calculatorFunction == .secondFunction:
            let update: ArithmeticUpdate.ShowSecondFunctionsUpdate = ArithmeticUpdate.ShowSecondFunctionsUpdate.arithmeticUpdate(for: self.arithmeticValues.currentFunctionWithTwoInputs)
            
            self.process(update: update)
            self.process(update: update.displayTermUpdate)
        case termCategory == .trigonometricFunction:
            let update: ArithmeticUpdate.TrigonometricFunctionUpdate = ArithmeticUpdate.TrigonometricFunctionUpdate.arithmeticUpdate(for: self.arithmeticValues.currentPrecedenceOperation)
            
            self.process(update: update, function: calculatorFunction)
            self.process(update: update.displayTermUpdate)
        default:
            break
        }
    }
    
    func process(update: ArithmeticUpdate.DisplayTerm) {
        switch update {
        case .noUpdate, .updatedDuringArithmeticUpdate:
            break
        case .updateFromInput1FunctionOneInput:
            guard let input1 = (self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? FunctionOneInput)?.input1 else { fatalError() }
            self.displayTerm = input1
        case .updateFromInput1FromFunctionTwoInputs:
            guard let input1 = (self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? FunctionTwoInputs)?.input1 else { fatalError() }
            self.displayTerm = input1
        case .updateFromInput2:
            guard let input2 = (self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? FunctionTwoInputs)?.input2 else { fatalError() }
            self.displayTerm = input2
        case .updateFromLastTerm:
            guard let lastTerm = self.arithmeticValues.currentPrecedenceOperation.lastTermAdded else { fatalError() }
            self.displayTerm = lastTerm
        case .updateWithParentheticalExpressionTotal, .updateWithPrecedenceOperationTotal:
            guard let leftTerm = self.arithmeticValues.currentPrecedenceOperation.leftTerm else { fatalError() }
            self.displayTerm = DoubleNumber(term: leftTerm)
        }
    }
    
    func process(update: ArithmeticUpdate.ClearAllEntriesUpdate) {
        switch update {
        case .resetParentheticalExpressionContainerWithStartingTermZero:
            let startingTerm = MutableNumber(digit: .zero)
            self.arithmeticValues.resetParentheticalExpressionContainers(startingTerm: startingTerm)
        }
    }
    
    func process(update: ArithmeticUpdate.ClosingParenthesisUpdate) {
        switch update {
        case .doNothing:
            return
        case .closeParentheticalExpressionEmpty:
            self.arithmeticValues.parentheticalExpressionContainers.last?.parentheticalExpressions.removeLast()
        case .closeParentheticalExpressionWithValue:
            let parentheticalExpression = self.arithmeticValues.parentheticalExpressionContainers.last?.parentheticalExpressions.removeLast()
            let doubleNumber = DoubleNumber(doubleValue: parentheticalExpression?.doubleValue)
            self.arithmeticValues.currentPrecedenceOperation.add(newTerm: doubleNumber)
        case .closeInput2ParentheticalExpressionContainerEmpty:
            self.arithmeticValues.parentheticalExpressionContainers.removeLast()
            let functionTwoInputs = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as! FunctionTwoInputs
            functionTwoInputs.input2 = nil
        case .closeInput2ParentheticalExpressionContainerWithValue:
            let parentheticalExpressionContainer = self.arithmeticValues.parentheticalExpressionContainers.removeLast()
            let doubleNumber = DoubleNumber(doubleValue: parentheticalExpressionContainer.doubleValue)
            let functionTwoInputs = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as! FunctionTwoInputs
            functionTwoInputs.input2 = doubleNumber
        case .preview:
            let parentheticalExpression = self.arithmeticValues.currentParentheticalExpression
            let doubleValue = parentheticalExpression.doubleValue(with: self.displayTerm)
            self.displayTerm = DoubleNumber(doubleValue: doubleValue)
        }
    }
    
    func process(update: ArithmeticUpdate.ConstantUpdate, constant: CalculatorFunction) {
        let doubleNumber = DoubleNumber(constant: constant)
        switch update {
        case .addAsTerm:
            self.arithmeticValues.currentPrecedenceOperation.add(newTerm: doubleNumber)
        case .replaceLastTerm:
            self.arithmeticValues.currentPrecedenceOperation.add(termReplacement: doubleNumber)
        case .addAsInput2:
            guard let functionTwoInputs = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? FunctionTwoInputs else { fatalError() }
            functionTwoInputs.input2 = DoubleNumber(constant: constant)
        }
    }
    
    func process(update: ArithmeticUpdate.DecimalUpdate) {
        switch update {
        case .addAsTerm:
            let mutableNumber = MutableNumber(decimalAdded: true)
            self.arithmeticValues.currentPrecedenceOperation.add(newTerm: mutableNumber)
        case .replaceLastTerm:
            let mutableNumber = MutableNumber(decimalAdded: true)
            self.arithmeticValues.currentPrecedenceOperation.add(termReplacement: mutableNumber)
        case .updateLastTerm:
            guard let term: MutableNumber = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? MutableNumber else { fatalError() }
            term.addDecimal()
        case .doNothing:
            return
        case .addAsInput2:
            guard let functionTwoInputs = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? FunctionTwoInputs else { fatalError() }
            functionTwoInputs.input2 = MutableNumber(decimalAdded: true)
        case .updateInput2:
            guard let functionTwoInputs = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? FunctionTwoInputs else { fatalError() }
            guard let mutableNumber = functionTwoInputs.input2 as? MutableNumber else { fatalError() }
            mutableNumber.addDecimal()
        }
    }
    
    func process(update: ArithmeticUpdate.MutableNumberUpdate, digit: CalculatorFunction) {
        switch update {
        case .addAsTerm:
            let mutableNumber = MutableNumber(digit: digit)
            self.arithmeticValues.currentPrecedenceOperation.add(newTerm: mutableNumber)
        case .replaceLastTerm:
            let mutableNumber = MutableNumber(digit: digit)
            self.arithmeticValues.currentPrecedenceOperation.add(termReplacement: mutableNumber)
        case .updateLastTerm:
            let term: MutableNumber = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as! MutableNumber
            term.addDigit(digit: digit)
        case .doNothing:
            return
        case .replaceInput2:
            guard let functionTwoInputs = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? FunctionTwoInputs else { fatalError() }
            functionTwoInputs.input2 = MutableNumber(digit: digit)
        case .updateInput2:
            guard let functionTwoInputs = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? FunctionTwoInputs else { fatalError() }
            guard let input2 = functionTwoInputs.input2 as? MutableNumber else { fatalError() }
            input2.addDigit(digit: digit)
        }
    }
    
    func process(update: ArithmeticUpdate.FunctionOneInputUpdate, function: CalculatorFunction) {
        switch update {
        case .addWithInput1FromDisplayTermToDisplayTerm:
            let input1: TermProtocol = self.displayTerm
            let functionOneInput = FunctionOneInput(function: function, input1: input1)
            self.displayTerm = functionOneInput
        case .addWithInput1FromLastTermToLastTerm:
            let input1: TermProtocol = self.arithmeticValues.currentPrecedenceOperation.termToUpdate!
            let functionOneInput = FunctionOneInput(function: function, input1: input1)
            self.arithmeticValues.currentPrecedenceOperation.add(termReplacement: functionOneInput)
        }
    }
    
    func process(update: ArithmeticUpdate.FunctionTwoInputsUpdate, function: CalculatorFunction) {
        switch update {
        case .addWithInput1FromLastTermAfterMovingLastOperationWithValueToCurrentPrecedence:
            guard let parentheticalExpression = self.arithmeticValues.parentheticalExpressionContainers.last?.lastParentheticalExpressionWithValue else { fatalError() }
            let operation = parentheticalExpression.removeCurrentPrecedenceOperation()!
            operation.basicOperator = nil
            self.arithmeticValues.currentPrecedenceOperation.importValues(from: operation)
            let input1 = self.arithmeticValues.currentPrecedenceOperation.lastTermAdded
            let functionTwoInputs = FunctionTwoInputs(function: function, input1: input1!)
            self.arithmeticValues.currentPrecedenceOperation.add(termReplacement: functionTwoInputs)
        case .addWithInput1FromLastTerm:
            let input1 = self.arithmeticValues.currentPrecedenceOperation.termToUpdate
            let functionTwoInputs = FunctionTwoInputs(function: function, input1: input1!)
            self.arithmeticValues.currentPrecedenceOperation.add(termReplacement: functionTwoInputs)
        case .replaceFunctionTwoInputsKeepingInput1:
            let lastFunctionTwoInputs = self.arithmeticValues.parentheticalExpressionContainers.first!.parentheticalExpressions.last!.currentPrecedenceOperation.termToUpdate as! FunctionTwoInputs
            let input1 = lastFunctionTwoInputs.input1
            let functionTwoInputs = FunctionTwoInputs(function: function, input1: input1)
            self.arithmeticValues.currentPrecedenceOperation.add(termReplacement: functionTwoInputs)
        }
    }
    
    func process(update: ArithmeticUpdate.MemoryRecallUpdate) {
        switch update {
        case .addAsTerm:
            let memoryRecall = MemoryRecall(doubleValue: self.arithmeticValues.memoryRecall.doubleValue)
            self.arithmeticValues.currentPrecedenceOperation.add(newTerm: memoryRecall)
        case .addDisplayNumberDoubleValue:
            self.arithmeticValues.memoryRecall.increase(by: self.displayTerm.doubleValue)
        case .reset:
            self.arithmeticValues.memoryRecall.clear()
        case .subtractDisplayNumberDoubleValue:
            self.arithmeticValues.memoryRecall.decrease(by: self.displayTerm.doubleValue)
        case .addAsInput2:
            guard let functionTwoInputs = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? FunctionTwoInputs else { fatalError() }
            functionTwoInputs.input2 = MemoryRecall(doubleValue: self.arithmeticValues.memoryRecall.doubleValue)
        }
    }
    
    func process(update: ArithmeticUpdate.OpeningParenthesisUpdate) {
        switch update {
        case .addAsParentheticalExpressionContainerForInput2WithInput2AsStartingTerm:
            guard let termToUpdate = self.arithmeticValues.currentPrecedenceOperation.termToUpdate else { fatalError() }
            guard let function2Inputs = termToUpdate as? FunctionTwoInputs else { fatalError() }
            let parentheticalExpressionContainer = ParentheticalExpressionContainer(reverseFunctionTwoInputs: function2Inputs, startingTerm: function2Inputs.input2)
            function2Inputs.input2 = parentheticalExpressionContainer
            self.arithmeticValues.parentheticalExpressionContainers.append(parentheticalExpressionContainer)
        case .addAsParentheticalExpressionWithLastTermAsStartingTerm:
            let startingTerm = self.arithmeticValues.currentPrecedenceOperation.termForNewParentheticalExpression()
            self.arithmeticValues.parentheticalExpressionContainers.last?.addParentheticalExpression(startingTerm: startingTerm)
        }
    }

    func process(update: ArithmeticUpdate.BasicOperatorUpdate, basicOperator: CalculatorFunction) {
        switch update {
        case .addAfterMovingLastOperationWithValueToCurrentPrecedence:
            guard let parentheticalExpression = self.arithmeticValues.parentheticalExpressionContainers.last?.lastParentheticalExpressionWithValue else { fatalError() }
            let operation = parentheticalExpression.removeCurrentPrecedenceOperation()!
            self.arithmeticValues.currentPrecedenceOperation.importValues(from: operation)
            self.arithmeticValues.currentPrecedenceOperation.basicOperator = basicOperator
        case .addAfterPrecedencePromotion:
            self.arithmeticValues.parentheticalExpressionContainers.last!.parentheticalExpressions.last!.promotePrecedence(basicOperator: basicOperator)
        case .addAfterPrecedenceDemotion:
            self.arithmeticValues.parentheticalExpressionContainers.last!.parentheticalExpressions.last!.demotePrecedence(basicOperator: basicOperator)
        case .addAsPrecedenceOperator:
            self.arithmeticValues.currentPrecedenceOperation.basicOperator = basicOperator
        case .addAfterRefactoringHighPrecedenceToLeftTermAsDoubleNumber:
            self.arithmeticValues.currentParentheticalExpression.refactorPrecedenceToLeftTerm(precedence: .high, arithmenticOperator: basicOperator)
        case .addAfterRefactoringLowPrecedenceToLeftTermAsOperation:
            self.arithmeticValues.currentParentheticalExpression.refactorPrecedenceToLeftTerm(precedence: .low, arithmenticOperator: basicOperator)
        case .addAfterReplaceFunction2InputsWithInput1:
            guard let functionWithTwoInputs = self.arithmeticValues.currentFunctionWithTwoInputs else { fatalError() }
            self.arithmeticValues.currentPrecedenceOperation.add(termReplacement: functionWithTwoInputs.input1)
            self.evaluate(calculatorFunction: basicOperator)
        }
    }
    
    func process(update: ArithmeticUpdate.PercentageFunctionUpdate) {
        switch update {
        case .replaceInput2UsingInput2PercentOf100:
            guard let functionTwoInputs = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? FunctionTwoInputs else { fatalError() }
            guard let input2 = functionTwoInputs.input2 else { fatalError() }
            
            let percentageFunction = PercentageFunction(termPercentOf100: input2)
            functionTwoInputs.input2 = percentageFunction
        case .replaceLastTermUsingLastTermPercentOf100:
            guard let termToUpdate = self.arithmeticValues.currentPrecedenceOperation.termToUpdate else { fatalError() }
            
            let percentageFunction = PercentageFunction(termPercentOf100: termToUpdate)
            self.arithmeticValues.currentPrecedenceOperation.add(termReplacement: percentageFunction)
        case .replaceLastTermUsingRightTermPercentOfLeftTerm:
            let precedenceOperation = self.arithmeticValues.currentPrecedenceOperation
            guard let leftTerm = precedenceOperation.leftTerm else { fatalError() }
            guard let rightTerm = precedenceOperation.rightTerm else { fatalError() }
            
            let percentageFunction = PercentageFunction(termPercent: rightTerm, ofTerm: leftTerm)
            precedenceOperation.rightTerm = percentageFunction
        case .replaceDisplayTermUsingDisplayTermPercentOf100:
            let percentageFunction = PercentageFunction(termPercentOf100: self.displayTerm)
            self.displayTerm = percentageFunction
        }
    }
    
    func process(update: ArithmeticUpdate.CalculatorResultUpdate) {
        switch update {
        case .continueLastTerm:
            guard let calculatorResult = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? CalculatorResult else { fatalError() }
            calculatorResult.continueTerm()
        case .addAsTermAfterResetingParentheticalExpressionContainersWith:
            if self.arithmeticValues.currentPrecedenceOperation.termToUpdate == nil {
                self.arithmeticValues.currentPrecedenceOperation.add(newTerm: self.displayTerm)
            }
            let parentheticalExpressionContainers = self.arithmeticValues.parentheticalExpressionContainers.filter { $0.reverseFunctionTwoInputs == nil }
            let calculatorResult = CalculatorResult(parentheticalExpressionContainers: parentheticalExpressionContainers.first!, displayTerm: self.displayTerm)
            self.arithmeticValues.resetParentheticalExpressionContainers(startingTerm: calculatorResult)
        }
    }
    
    func process(update: ArithmeticUpdate.NegateNumberSignUpdate) {
        switch update {
        case .addAsTerm:
            let mutableNumber = MutableNumber(shouldToggleNumberSign: true)
            self.arithmeticValues.currentPrecedenceOperation.add(newTerm: mutableNumber)
        case .updateLastTerm:
            guard let term: TermProtocol = self.arithmeticValues.currentPrecedenceOperation.termToUpdate else { fatalError() }
            term.negateNumber = !term.negateNumber
        case .addAsInput2:
            guard let functionTwoInputs = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? FunctionTwoInputs else { fatalError() }
            functionTwoInputs.input2 = MutableNumber(shouldToggleNumberSign: true)
        case .updateInput2:
            guard let functionTwoInputs = self.arithmeticValues.currentPrecedenceOperation.termToUpdate as? FunctionTwoInputs else { fatalError() }
            functionTwoInputs.input2!.negateNumber.toggle()
        }
    }
    
    func process(update: ArithmeticUpdate.SIUnitUpdate, siUnit: CalculatorFunction) {
        switch update {
        case .updateSIUnit:
            self.arithmeticValues.siUnit = siUnit
        }
    }
    
    func process(update: ArithmeticUpdate.ShowSecondFunctionsUpdate) {
        switch update {
        case .replaceLastTermWithInput1:
            guard let precedenceOperation: PrecedenceOperation = {
                for parentheticalExpressionContainer in self.arithmeticValues.parentheticalExpressionContainers {
                    let termToUpdate = parentheticalExpressionContainer.parentheticalExpressions.last?.currentPrecedenceOperation.termToUpdate
                    if (termToUpdate as? FunctionTwoInputs)?.function == .baseYPowerX {
                        return parentheticalExpressionContainer.parentheticalExpressions.last?.currentPrecedenceOperation
                    }
                }
                return nil
            }() else { fatalError() }
            guard let input1 = (precedenceOperation.termToUpdate as? FunctionTwoInputs)?.input1 else { fatalError() }
            
            precedenceOperation.add(termReplacement: input1)
            self.arithmeticValues.parentheticalExpressionContainers.removeLast()
        case .doNothing:
            return
        }
    }
    
    func process(update: ArithmeticUpdate.TrigonometricFunctionUpdate, function: CalculatorFunction) {
        switch update {
        case .addWithInput1FromDisplayTermToDisplayTerm:
            let input1: TermProtocol = self.displayTerm
            let trigonometricFunction = TrigonometricFunction(function: function, input1: input1, siUnit: self.arithmeticValues.siUnit)
            self.displayTerm = trigonometricFunction
        case .addWithInput1FromLastTermToLastTerm:
            let input1: TermProtocol = self.arithmeticValues.currentPrecedenceOperation.termToUpdate!
            let trigonometricFunction = TrigonometricFunction(function: function, input1: input1, siUnit: self.arithmeticValues.siUnit)
            self.arithmeticValues.currentPrecedenceOperation.add(termReplacement: trigonometricFunction)
        }
    }

    // MARK: - Transformable
    
    enum Key: String {
        case displayTerm
        case displayTermTermType
        case siUnit
        case parentheticalExpressionContainers
        case memoryRecall
        case memoryRecallTermType
    }
    
    public static var supportsSecureCoding: Bool { return true }

    public required init?(coder: NSCoder) {
        let memoryRecall: MemoryRecall = {
            guard let term = coder.decodeObject(of: MemoryRecall.self, forKey: Key.memoryRecall.rawValue) else { fatalError() }
            return term
        }()
        let parentheticalExpressionContainers: [ParentheticalExpressionContainer] = {
            guard let containers = coder.decodeObject(of: [NSArray.self, ParentheticalExpressionContainer.self], forKey: Key.parentheticalExpressionContainers.rawValue) else { fatalError() }
            return Array(_immutableCocoaArray: containers as! NSArray)
        }()
        let siUnit: CalculatorFunction = {
            guard let nsString = coder.decodeObject(of: NSString.self, forKey: Key.siUnit.rawValue) else { fatalError() }
            guard let function: CalculatorFunction = .init(rawValue: String(nsString)) else { fatalError() }
            return function
        }()
            
        self.arithmeticValues = ArithmeticValues(memoryRecall: memoryRecall, parentheticalExpressonContainers: parentheticalExpressionContainers, siUnit: siUnit)
        
        self.displayTerm = {
            guard let termType: Term = {
                guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.displayTermTermType.rawValue) else { fatalError() }
                guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
                return termType
            }() else { fatalError() }
            let termKey = Key.displayTerm.rawValue
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
        coder.encode(self.arithmeticValues.memoryRecall, forKey: Key.memoryRecall.rawValue)
        
        coder.encode(self.arithmeticValues.parentheticalExpressionContainers, forKey: Key.parentheticalExpressionContainers.rawValue)

        coder.encode(NSString(string:self.arithmeticValues.siUnit.rawValue), forKey: Key.siUnit.rawValue)

        coder.encode(self.displayTerm, forKey: Key.displayTerm.rawValue)
        coder.encode(NSNumber(value: self.displayTerm.termType.rawValue), forKey: Key.displayTermTermType.rawValue)
    }
}

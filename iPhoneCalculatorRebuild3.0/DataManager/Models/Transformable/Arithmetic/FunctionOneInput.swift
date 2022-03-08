//
//  FunctionOneInput.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class FunctionOneInput: NSObject, NSSecureCoding, TermProtocol {

    // MARK: - Properties

    let function: CalculatorFunction
    var input1: TermProtocol

    // MARK: - Init

    init(function: CalculatorFunction, input1: TermProtocol) {
        self.function = function
        self.input1 = input1
        self.negateNumber = false
        self.termTestIdentifier = UUID()
        self.termType = .functionOneInput
    }
    
    // MARK: - Methods

    func evaluateFunction() -> Double? {
        guard let input1DoubleValue = self.input1.doubleValue else { return nil }
        let evaluedFunctionDouble: Double? = {
            switch self.function {
            case .baseEulersNumberPowerX:
                return pow(input1DoubleValue, Darwin.M_E)
            case .baseTenPowerX:
                return pow(input1DoubleValue, 10)
            case .baseTwoPowerX:
                return pow(2, input1DoubleValue)
            case .baseXPowerThree:
                return pow(input1DoubleValue, 3)
            case .baseXPowerTwo:
                return pow(input1DoubleValue, 2)
            case .factorial:
                //1.Avoid using factorial on numbers with a decimal value > 0
                guard input1DoubleValue.rounded() == input1DoubleValue else { return nil }

                func factorial(double: Double) -> Double {
                    return double == 0 ? 1 : double * factorial(double: double - 1)
                }
                return factorial(double: input1DoubleValue)
            case .logBaseTen:
                return log10(input1DoubleValue)
            case .logBaseTwo:
                return log2(input1DoubleValue)
            case .naturalLog:
                return log(input1DoubleValue)
            case .reciprocal:
                guard input1DoubleValue != 0 else { return nil }
                return 1 / input1DoubleValue
            case .coefficientThreeRadicandX:
                return cbrt(input1DoubleValue)
            case .coefficientTwoRadicandX:
                return sqrt(input1DoubleValue)
            default:
                fatalError("Function in term is not a function with 1 input or it the function with one input is not handled in the above cases")
            }
        }()
        return evaluedFunctionDouble
    }
    
    // MARK: - Term Protocol
    
    var doubleValue: Double? {
        guard let evaluatedDoubleValue = self.evaluateFunction() else { return nil }
        return evaluatedDoubleValue * self.negateNumber.signNegationDoubleValue
    }
    var negateNumber: Bool
    var termType: Term
    var termTestIdentifier: UUID
    
    // MARK: - Transformable
    
    enum Key: String {
        case input1
        case input1TermType
        case termType
        case negateNumber
        case termTestIdentifier
        case function
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
        self.input1 = {
            let termType: Term = {
                guard let number = coder.decodeObject(of: NSNumber.self, forKey: Key.input1TermType.rawValue) else { fatalError() }
                guard let termType = Term.init(rawValue: number.intValue) else { fatalError() }
                return termType
            }()
            let termKey = Key.input1.rawValue
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
        self.function = {
            guard let nsString = coder.decodeObject(of: NSString.self, forKey: Key.function.rawValue) else { fatalError() }
            guard let function: CalculatorFunction = .init(rawValue: String(nsString)) else { fatalError() }
            return function
        }()
    }
    
    public func encode(with coder: NSCoder) {
        self.encodeTestProtocol(coder: coder)
        coder.encode(NSString(string: self.function.rawValue), forKey: Key.function.rawValue)
        coder.encode(self.input1, forKey: Key.input1.rawValue)
        coder.encode(NSNumber(value: self.input1.termType.rawValue), forKey: Key.input1TermType.rawValue)
    }
}

//
//  CalculatorFunction.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

enum CalculatorFunction: String {
    case allClear = "AC"
    case clearEntry = "C"
    case eulersNumber = "e"
    case pi = "π"
    case randomNumber = "Rand"
    case decimal = "."
    case eight = "8"
    case five = "5"
    case four = "4"
    case nine = "9"
    case one = "1"
    case seven = "7"
    case six = "6"
    case three = "3"
    case two = "2"
    case zero = "0"
    case result = "="
    case baseEulersNumberPowerX = "ex"
    case baseTenPowerX = "10x"
    case baseTwoPowerX = "2x"
    case baseXPowerThree = "x3"
    case baseXPowerTwo = "x2"
    case baseXPowerY = "xy"
    case baseYPowerX = "yx"
    case enterExponent = "EE"
    case factorial = "x!"
    case logBaseTen = "log10"
    case logBaseTwo = "log2"
    case logBaseY = "logy"
    case naturalLog = "ln"
    case memoryClear = "mc"
    case memoryMinus = "m-"
    case memoryPlus = "m+"
    case memoryRecall = "mr"
    case addition = "+"
    case division = "÷"
    case multiplication = "×"
    case subtraction = "−"
    case closingParenthesis = ")"
    case openingParenthesis = "("
    case percent = "%"
    case reciprocal = "¹⁄x"
    case coefficientThreeRadicandX = "³√⎺x"
    case coefficientTwoRadicandX = "²√⎺x"
    case coefficientYRadicandX = "ʸ√⎺x"
    case degrees = "Deg"
    case radians = "Rad"
    case signChange = "⁺⁄₋"
    case secondFunction = "2nd"
    case hyperbolicCosine = "cosh"
    case hyperbolicSine = "sinh"
    case hyperbolicTangent = "tanh"
    case inverseHyperbolicCosine = "cosh-1"
    case inverseHyperbolicSine = "sinh-1"
    case inverseHyperbolicTangent = "tanh-1"
    case inverseRightAngleCosine = "cos-1"
    case inverseRightAngleSine = "sin-1"
    case inverseRightAngleTangent = "tan-1"
    case rightAngleCosine = "cos"
    case rightAngleSine = "sin"
    case rightAngleTangent = "tan"

    // MARK: - Init
    
    init?(rawValue: NSString) {
        guard let calculatorFunction = CalculatorFunction.init(rawValue: String(rawValue)) else { fatalError() }
        self = calculatorFunction
    }
    
    // MARK: - Models
    
    enum AdditionalFunctions {
        case first
        case second
        
        var calculatorFunctions: [CalculatorFunction] {
            switch self {
            case .first:
                return [.baseEulersNumberPowerX, .baseTenPowerX, .naturalLog, .logBaseTen, .rightAngleSine, .rightAngleCosine, .rightAngleTangent, .hyperbolicSine, .hyperbolicCosine, .hyperbolicTangent]
            case .second:
                return [.baseYPowerX, .baseTwoPowerX, .logBaseY, .logBaseTwo, .inverseRightAngleSine, .inverseRightAngleCosine, .inverseRightAngleTangent, .inverseHyperbolicSine, .inverseHyperbolicCosine, .inverseHyperbolicTangent]
            }
        }
        
        mutating func toggle() {
            switch self {
            case .first:
                self = AdditionalFunctions.second
            case .second:
                self = AdditionalFunctions.first
            }
        }
    }
    
    enum FunctionCategory {
        case entryClearer
        case constant
        case decimal
        case digit
        case result
        case exponentFunction
        case factorial
        case logFunction
        case memoryRecall
        case basicOperator
        case parentheses
        case percentageFunction
        case reciprocal
        case rootFunction
        case siUnit
        case toggleNumberSign
        case toggleSecondSetOfFunctions
        case trigonometricFunction
        
        init(calculatorFunction: CalculatorFunction) {
            let functionCategory: FunctionCategory = {
                switch calculatorFunction {
                case .allClear, .clearEntry:
                    return .entryClearer
                case .eulersNumber, .pi, .randomNumber:
                    return .constant
                case .decimal:
                    return .decimal
                case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
                    return .digit
                case .result:
                    return .result
                case .baseEulersNumberPowerX, .baseTenPowerX, .baseTwoPowerX, .baseXPowerThree, .baseXPowerTwo, .baseXPowerY, .baseYPowerX, .enterExponent:
                    return .exponentFunction
                case .factorial:
                    return .factorial
                case .logBaseTen, .logBaseTwo, .logBaseY, .naturalLog:
                    return .logFunction
                case .memoryClear, .memoryMinus, .memoryPlus, .memoryRecall:
                    return .memoryRecall
                case .addition, .division, .multiplication, .subtraction:
                    return .basicOperator
                case .closingParenthesis, .openingParenthesis:
                    return .parentheses
                case .percent:
                    return .percentageFunction
                case .reciprocal:
                    return .reciprocal
                case .coefficientThreeRadicandX, .coefficientTwoRadicandX, .coefficientYRadicandX:
                    return .rootFunction
                case .degrees, .radians:
                    return .siUnit
                case .signChange:
                    return .toggleNumberSign
                case .secondFunction:
                    return .toggleSecondSetOfFunctions
                case .hyperbolicCosine, .hyperbolicSine, .hyperbolicTangent, .inverseHyperbolicCosine, .inverseHyperbolicSine, .inverseHyperbolicTangent, .inverseRightAngleCosine, .inverseRightAngleSine, .inverseRightAngleTangent, .rightAngleCosine, .rightAngleSine, .rightAngleTangent:
                    return .trigonometricFunction
                }
            }()
            self = functionCategory
        }
    }
    
    enum TermCategory {
        case constant
        case doubleNumberValue
        case functionOneInput
        case functionTwoInputs
        case mutableNumberValue
        case operation
        case nestedArithmeticController
        case percentageFunction
        case trigonometricFunction
        
        init?(calculatorFunction: CalculatorFunction) {
            guard let termCategory: TermCategory = {
                switch calculatorFunction {
                case .eulersNumber, .pi, .randomNumber:
                    return .constant
                case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
                    return .doubleNumberValue
                case .baseEulersNumberPowerX, .baseTenPowerX, .baseTwoPowerX, .baseXPowerThree, .baseXPowerTwo:
                    return .functionOneInput
                case  .baseXPowerY, .baseYPowerX, .enterExponent:
                    return .functionTwoInputs
                case .factorial:
                    return .functionOneInput
                case .logBaseTen, .logBaseTwo, .naturalLog:
                    return .functionOneInput
                case .logBaseY:
                    return .functionTwoInputs
                case .memoryRecall:
                    return .doubleNumberValue
                case .percent:
                    return .percentageFunction
                case .reciprocal:
                    return .functionOneInput
                case .coefficientThreeRadicandX, .coefficientTwoRadicandX:
                    return .functionOneInput
                case .coefficientYRadicandX:
                    return .functionTwoInputs
                case .hyperbolicCosine, .hyperbolicSine, .hyperbolicTangent, .inverseHyperbolicCosine, .inverseHyperbolicSine, .inverseHyperbolicTangent, .inverseRightAngleCosine, .inverseRightAngleSine, .inverseRightAngleTangent, .rightAngleCosine, .rightAngleSine, .rightAngleTangent:
                    return .trigonometricFunction
                default:
                    return nil
                }
            }() else { return nil }
            self = termCategory
        }
    }
    
    // MARK: - All Functions Info
    
    static var all: [CalculatorFunction] {
        return [
        .allClear,
        .clearEntry,
        .eulersNumber,
        .pi,
        .randomNumber,
        .decimal,
        .eight,
        .five,
        .four,
        .nine,
        .one,
        .seven,
        .six,
        .three,
        .two,
        .zero,
        .result,
        .baseEulersNumberPowerX,
        .baseTenPowerX,
        .baseTwoPowerX,
        .baseXPowerThree,
        .baseXPowerTwo,
        .baseXPowerY,
        .baseYPowerX,
        .enterExponent,
        .factorial,
        .logBaseTen,
        .logBaseTwo,
        .logBaseY,
        .naturalLog,
        .memoryClear,
        .memoryMinus,
        .memoryPlus,
        .memoryRecall,
        .addition,
        .division,
        .multiplication,
        .subtraction,
        .closingParenthesis,
        .openingParenthesis,
        .percent,
        .reciprocal,
        .coefficientThreeRadicandX,
        .coefficientTwoRadicandX,
        .coefficientYRadicandX,
        .degrees,
        .radians,
        .signChange,
        .secondFunction,
        .hyperbolicCosine,
        .hyperbolicSine,
        .hyperbolicTangent,
        .inverseHyperbolicCosine,
        .inverseHyperbolicSine,
        .inverseHyperbolicTangent,
        .inverseRightAngleCosine,
        .inverseRightAngleSine,
        .inverseRightAngleTangent,
        .rightAngleCosine,
        .rightAngleSine,
        .rightAngleTangent
        ]
    }
    
    static func defaultLayout(for calculator: Calculator) -> [CalculatorFunction] {
        let startingCalculatorFunctions = CalculatorFunction.all.filter { $0.isActiveOnFirstLoad }
        switch calculator {
        case .scientific:
            let startingScientificFunctions: [CalculatorFunction] = startingCalculatorFunctions.filter { $0.itemNumber(for: .scientific) != nil }
            let startingScientificFunctionsSorted = startingScientificFunctions.sorted { left, right in
                return left.itemNumber(for: .scientific)! < right.itemNumber(for: .scientific)!
            }
            return startingScientificFunctionsSorted
        case .standard:
            let startingStandardFunctions: [CalculatorFunction] = startingCalculatorFunctions.filter { $0.itemNumber(for: .standard) != nil }
            let startingStandardFunctionsSorted = startingStandardFunctions.sorted { left, right in
                return left.itemNumber(for: .standard)! < right.itemNumber(for: .standard)!
            }
            return startingStandardFunctionsSorted
        }
    }

    static var startingCalculatorFunctions: [CalculatorFunction] {
        let starting = self.all.filter { $0.isActiveOnFirstLoad }
        
        return starting
    }

    // MARK: - Function Info

    var hasNumberValue: Bool {
        switch self {
        case .eulersNumber,
            .pi,
            .randomNumber,
            .decimal,
            .eight,
            .five,
            .four,
            .nine,
            .one,
            .seven,
            .six,
            .three,
            .two,
            .zero:
            return true
        default:
            return false
        }
    }

    var hasSelectedAppearance: Bool {
        switch self {
        case .secondFunction:
            return true
        case .addition, .subtraction, .multiplication, .division:
            return true
        case .coefficientYRadicandX,
             .logBaseY,
             .baseYPowerX,
             .baseXPowerY,
             .enterExponent:
            return true
        default:
            return false
        }
    }

    var isActiveOnFirstLoad: Bool {
        switch self {
        case .clearEntry,
             .radians,
             .inverseHyperbolicSine,
             .inverseHyperbolicCosine,
             .inverseHyperbolicTangent,
             .inverseRightAngleSine,
             .inverseRightAngleCosine,
             .inverseRightAngleTangent,
             .logBaseY,
             .logBaseTwo,
             .baseYPowerX,
             .baseTwoPowerX:
            return false
        default:
            return true
        }
    }

    var nsString: NSString {
        return NSString(string: self.rawValue)
    }

    func itemNumber(for calculator: Calculator) -> Int? {
        switch calculator {
        case .scientific:
            switch self {
            case .allClear:
                return 6
            case .clearEntry:
                return 6
            case .eulersNumber:
                return 34
            case .pi:
                return 44
            case .randomNumber:
                return 45
            case .decimal:
                return 47
            case .zero:
                return 46
            case .one:
                return 36
            case .two:
                return 37
            case .three:
                return 38
            case .four:
                return 26
            case .five:
                return 27
            case .six:
                return 28
            case .seven:
                return 16
            case .eight:
                return 17
            case .nine:
                return 18
            case .result:
                return 48
            case .baseEulersNumberPowerX:
                return 14
            case .baseTenPowerX:
                return 15
            case .baseTwoPowerX:
                return 15
            case .baseXPowerThree:
                return 12
            case .baseXPowerTwo:
                return 11
            case .baseXPowerY:
                return 13
            case .baseYPowerX:
                return 14
            case .enterExponent:
                return 35
            case .factorial:
                return 30
            case .logBaseTen:
                return 25
            case .logBaseTwo:
                return 25
            case .logBaseY:
                return 24
            case .naturalLog:
                return 24
            case .memoryClear:
                return 2
            case .memoryMinus:
                return 4
            case .memoryPlus:
                return 3
            case .memoryRecall:
                return 5
            case .addition:
                return 39
            case .division:
                return 9
            case .multiplication:
                return 19
            case .subtraction:
                return 29
            case .closingParenthesis:
                return 1
            case .openingParenthesis:
                return 0
            case .percent:
                return 8
            case .reciprocal:
                return 20
            case .coefficientThreeRadicandX:
                return 22
            case .coefficientTwoRadicandX:
                return 21
            case .coefficientYRadicandX:
                return 23
            case .degrees:
                return 40
            case .radians:
                return 40
            case .signChange:
                return 7
            case .secondFunction:
                return 10
            case .hyperbolicCosine:
                return 42
            case .hyperbolicSine:
                return 41
            case .hyperbolicTangent:
                return 43
            case .inverseHyperbolicCosine:
                return 42
            case .inverseHyperbolicSine:
                return 41
            case .inverseHyperbolicTangent:
                return 43
            case .inverseRightAngleCosine:
                return 32
            case .inverseRightAngleSine:
                return 31
            case .inverseRightAngleTangent:
                return 33
            case .rightAngleCosine:
                return 32
            case .rightAngleSine:
                return 31
            case .rightAngleTangent:
                return 33
            }
        case .standard:
            switch self {
            case .allClear:
                return 0
            case .clearEntry:
                return 0
            case .decimal:
                return 17
            case .zero:
                return 16
            case .one:
                return 12
            case .two:
                return 13
            case .three:
                return 14
            case .four:
                return 8
            case .five:
                return 9
            case .six:
                return 10
            case .seven:
                return 4
            case .eight:
                return 5
            case .nine:
                return 6
            case .result:
                return 18
            case .addition:
                return 15
            case .division:
                return 3
            case .multiplication:
                return 7
            case .subtraction:
                return 11
            case .percent:
                return 2
            case .signChange:
                return 1
            default:
                return nil
            }
        }
    }
    
    func functionCategory() -> FunctionCategory {
        return FunctionCategory(calculatorFunction: self)
    }
    
    func termCategory() -> TermCategory? {
        return TermCategory(calculatorFunction: self)
    }
}

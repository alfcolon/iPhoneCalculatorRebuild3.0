//
//  TextFormatter.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

enum CustomFont {
    enum SFProDisplay: String {
        case light = "SFProDisplay-Light"
        case medium = "SFProDisplay-Medium"
        case regular = "SFProDisplay-Regular"
        case thin = "SFProDisplay-Thin"
    }
    enum SFProText: String {
        case light = "SFProText-Light"
        case medium = "SFProText-Medium"
        case regular = "SFProText-Regular"
        case thin = "SFProText-Thin"
    }
    
}

struct TextFormatter {
    struct CalculatorCollectionViewCellLabel {
        
        // MARK: - Attributed Formatter Models
        
        private struct ScientificCalculator {
            enum AttributedStringFormatter {
            case clearType(String)
            case constant(String)
            case decimal(String)
            case digit(String)
            case equal(String)
            case factorial(String)
            case exponentFunctionBase(String)
            case exponentFunctionExponent(String)
            case logFunctionBase(String)
            case logFunctionText(String)
            case _operator(String)
            case parenthesis(String)
            case percentageFunction(String)
            case memoryRecall(String)
            case reciprocalDenominator(String)
            case reciprocalNumerator(String)
            case reciprocalSolidus(String)
            case rootFunctionCoefficient(String)
            case rootFunctionCoefficientY(String)
            case rootFunctionRadicand(String)
            case rootFunctionRadicandY(String)
            case siUnit(String)
            case toggleNumberSignMinust(String)
            case toggleNumberSignPlus(String)
            case toggleNumberSignSolidus(String)
            case toggleSecondSetOfFunctionsText(String)
            case toggleSecondSetOfFunctionsSuperscript(String)
            case trigonometricFunctionText(String)
            case trigonometricFunctionInverseExponent(String)
            indirect case exponentFunction(AttributedStringFormatter, AttributedStringFormatter?)
            indirect case logFunction(AttributedStringFormatter, AttributedStringFormatter?)
            indirect case reciprocalFunction(AttributedStringFormatter, AttributedStringFormatter, AttributedStringFormatter)
            indirect case rootFunction(AttributedStringFormatter, AttributedStringFormatter)
            indirect case toggleNumberSign(AttributedStringFormatter, AttributedStringFormatter, AttributedStringFormatter)
            indirect case toggleSecondSetOfFunctions(AttributedStringFormatter, AttributedStringFormatter)
            indirect case trigonometricFunction(AttributedStringFormatter, AttributedStringFormatter?)

            //MARK: - NSAttributedString.Key's

            var baselineOffset: NSNumber {
                switch self {
                case .clearType,
                        .constant,
                        .decimal,
                        .digit,
                        .equal,
                        .factorial,
                        .exponentFunctionBase,
                        .logFunctionText,
                        ._operator,
                        .parenthesis,
                        .percentageFunction,
                        .memoryRecall,
                        .reciprocalSolidus,
                        .siUnit,
                        .toggleNumberSignMinust,
                        .toggleNumberSignPlus,
                        .toggleNumberSignSolidus,
                        .toggleSecondSetOfFunctionsText,
                        .trigonometricFunctionText:
                        return 0
                case .exponentFunctionExponent,
                        .toggleSecondSetOfFunctionsSuperscript:
                        return 5
                case .logFunctionBase:
                        return -2
                case .reciprocalDenominator:
                        return -1
                case .reciprocalNumerator:
                        return -1
                case .rootFunctionCoefficient:
                        return 5
                case .rootFunctionRadicand:
                        return 0
                case .rootFunctionRadicandY:
                        return 6
                case .trigonometricFunctionInverseExponent:
                        return 5
                default:
                    return 0
                }
            }
            var fontName: String {
                switch UITraitCollection.current.legibilityWeight {
                case .bold:
                    return CustomFont.SFProDisplay.medium.rawValue
                default:
                    return CustomFont.SFProDisplay.regular.rawValue
                }
            }
            var fontSize: CGFloat {
                switch self {
                case .constant,
                        .logFunctionText,
                        .memoryRecall,
                        .parenthesis,
                        .reciprocalNumerator,
                        .reciprocalSolidus,
                        .siUnit,
                        .toggleSecondSetOfFunctionsText,
                        .trigonometricFunctionText:
                    return 17
                case .clearType,
                        .decimal,
                        .digit,
                        .percentageFunction,
                        .toggleNumberSignMinust,
                        .toggleNumberSignPlus,
                        .toggleNumberSignSolidus:
                    return 25
                case .equal,
                        ._operator:
                    return 30
                case .exponentFunctionExponent,
                        .logFunctionBase,
                        .toggleSecondSetOfFunctionsSuperscript:
                    return 11
                case .reciprocalDenominator:
                    return 14
                case .rootFunctionCoefficient(let string):
                    return string == "ʸ" ? 20 : 10
                case .rootFunctionRadicand,
                        .rootFunctionRadicandY:
                    return 15
                case .trigonometricFunctionInverseExponent:
                    return 10
                default:
                    return 17
                }
            }
            var font: UIFont! {
                let name: String = self.fontName
                let size: CGFloat = self.fontSize
                guard let font = UIFont(name: name, size: size) else { fatalError("Cannot access \(name) font") }
                return font
            }
            var kern: Int {
                switch self {
                case .rootFunctionCoefficient:
                    return 5
                case .rootFunctionCoefficientY:
                    return 5
                default:
                    return 0
                }
            }
            func range(length: Int) -> NSRange {
                return NSRange(location: 0, length: length)
            }

            //MARK: - Part/Whole Attributed String Value
            
            var formattedAttributedString: NSAttributedString {
                switch self {
                case .clearType(let string):
                    return formatString(for: string)
                case .constant(let string):
                    return formatString(for: string)
                case .decimal(let string):
                    return formatString(for: string)
                case .digit(let string):
                    return formatString(for: string)
                case .equal(let string):
                    return formatString(for: string)
                case .factorial(let string):
                    return formatString(for: string)
                case .exponentFunctionBase(let string):
                    return formatString(for: string)
                case .exponentFunctionExponent(let string):
                    return formatString(for: string)
                case .logFunctionBase(let string):
                    return formatString(for: string)
                case .logFunctionText(let string):
                    return formatString(for: string)
                case ._operator(let string):
                    return formatString(for: string)
                case .parenthesis(let string):
                    return formatString(for: string)
                case .percentageFunction(let string):
                    return formatString(for: string)
                case .memoryRecall(let string):
                    return formatString(for: string)
                case .reciprocalDenominator(let string):
                    return formatString(for: string)
                case .reciprocalNumerator(let string):
                    return formatString(for: string)
                case .reciprocalSolidus(let string):
                    return formatString(for: string)
                case .rootFunctionCoefficient(let string):
                    return formatString(for: string)
                case .rootFunctionCoefficientY(let string):
                    return formatString(for: string)
                case .rootFunctionRadicand(let string):
                    return formatString(for: string)
                case .rootFunctionRadicandY(let string):
                    return formatString(for: string)
                case .siUnit(let string):
                    return formatString(for: string)
                case .toggleNumberSignMinust(let string):
                    return formatString(for: string)
                case .toggleNumberSignPlus(let string):
                    return formatString(for: string)
                case .toggleNumberSignSolidus(let string):
                    return formatString(for: string)
                case .toggleSecondSetOfFunctionsText(let string):
                    return formatString(for: string)
                case .toggleSecondSetOfFunctionsSuperscript(let string):
                    return formatString(for: string)
                case .trigonometricFunctionText(let string):
                    return formatString(for: string)
                case .trigonometricFunctionInverseExponent(let string):
                    return formatString(for: string)
                case .exponentFunction(let functionName, let exponent):
                    let mutableAttributedString = NSMutableAttributedString()
                    mutableAttributedString.append(functionName.formattedAttributedString)
                    if let exponent = exponent {
                        mutableAttributedString.append(exponent.formattedAttributedString)
                    }
                    return mutableAttributedString
                case .logFunction(let logFunctionText, let logFunctionBase):
                    let mutableAttributedString = NSMutableAttributedString()
                    mutableAttributedString.append(logFunctionText.formattedAttributedString)
                    if let base = logFunctionBase {
                        mutableAttributedString.append(base.formattedAttributedString)
                    }
                    return mutableAttributedString
                case .reciprocalFunction(let numerator, let solidus, let denominator):
                    let mutableAttributedString = NSMutableAttributedString()
                    mutableAttributedString.append(numerator.formattedAttributedString)
                    mutableAttributedString.append(solidus.formattedAttributedString)
                    mutableAttributedString.append(denominator.formattedAttributedString)
                    return mutableAttributedString
                case .rootFunction(let coefficient, let radicand):
                    let mutableAttributedString = NSMutableAttributedString()
                    mutableAttributedString.append(coefficient.formattedAttributedString)
                    mutableAttributedString.append(radicand.formattedAttributedString)
                    return mutableAttributedString
                case .toggleNumberSign(let plusSign, let solidus, let minusSign):
                    let mutableAttributedString = NSMutableAttributedString()
                    mutableAttributedString.append(plusSign.formattedAttributedString)
                    mutableAttributedString.append(solidus.formattedAttributedString)
                    mutableAttributedString.append(minusSign.formattedAttributedString)
                    return mutableAttributedString
                case .toggleSecondSetOfFunctions(let functionText, let superscript):
                    let mutableAttributedString = NSMutableAttributedString()
                    mutableAttributedString.append(functionText.formattedAttributedString)
                    mutableAttributedString.append(superscript.formattedAttributedString)
                    return mutableAttributedString
                case .trigonometricFunction(let functionName, let inverseExponent):
                    let mutableAttributedString = NSMutableAttributedString()
                    mutableAttributedString.append(functionName.formattedAttributedString)
                    if let exponent = inverseExponent {
                        mutableAttributedString.append(exponent.formattedAttributedString)
                    }
                    return mutableAttributedString
                }
            }

            func formatString(for string: String) -> NSMutableAttributedString {
                let mutableAttributedString = NSMutableAttributedString(string: string)

                let range = self.range(length: string.count)

                mutableAttributedString.addAttributes([NSAttributedString.Key.baselineOffset : self.baselineOffset], range: range)
                mutableAttributedString.addAttributes([NSAttributedString.Key.kern : self.kern], range: range)
                mutableAttributedString.addAttributes([NSAttributedString.Key.font : self.font!], range: range)

                return mutableAttributedString
            }
        }
        
            static func attributedString(calculatorFunction: CalculatorFunction) -> NSAttributedString {
            switch calculatorFunction {
            case .allClear,
                    .clearEntry:
                return AttributedStringFormatter.clearType(calculatorFunction.rawValue).formattedAttributedString
            case .eulersNumber,
                    .pi,
                    .randomNumber:
                return AttributedStringFormatter.constant(calculatorFunction.rawValue).formattedAttributedString
            case .decimal:
                return AttributedStringFormatter.decimal(calculatorFunction.rawValue).formattedAttributedString
            case .zero,
                    .one,
                    .two,
                    .three,
                    .four,
                    .five,
                    .six,
                    .seven,
                    .eight,
                    .nine:
                return AttributedStringFormatter.digit(calculatorFunction.rawValue).formattedAttributedString
            case .result:
                return AttributedStringFormatter.equal(calculatorFunction.rawValue).formattedAttributedString
            case .baseEulersNumberPowerX:
                return AttributedStringFormatter.exponentFunction(
                AttributedStringFormatter.exponentFunctionBase("e"),
                AttributedStringFormatter.exponentFunctionExponent("x")).formattedAttributedString
            case .baseTenPowerX:
                return AttributedStringFormatter.exponentFunction(
                    AttributedStringFormatter.exponentFunctionBase("10"),
                    AttributedStringFormatter.exponentFunctionExponent("x")).formattedAttributedString
            case .baseTwoPowerX:
                return AttributedStringFormatter.exponentFunction(
                    AttributedStringFormatter.exponentFunctionBase("2"),
                    AttributedStringFormatter.exponentFunctionExponent("x")).formattedAttributedString
            case .baseXPowerThree:
                return AttributedStringFormatter.exponentFunction(
                    AttributedStringFormatter.exponentFunctionBase("x"),
                    AttributedStringFormatter.exponentFunctionExponent("3")).formattedAttributedString
            case .baseXPowerTwo:
                return AttributedStringFormatter.exponentFunction(
                    AttributedStringFormatter.exponentFunctionBase("x"),
                    AttributedStringFormatter.exponentFunctionExponent("2")).formattedAttributedString
            case .baseXPowerY:
                return AttributedStringFormatter.exponentFunction(
                    AttributedStringFormatter.exponentFunctionBase("x"),
                    AttributedStringFormatter.exponentFunctionExponent("y")).formattedAttributedString
            case .baseYPowerX:
                return AttributedStringFormatter.exponentFunction(
                    AttributedStringFormatter.exponentFunctionBase("y"),
                    AttributedStringFormatter.exponentFunctionExponent("x")).formattedAttributedString
            case .enterExponent:
                return AttributedStringFormatter.exponentFunctionBase("EE").formattedAttributedString
            case .factorial:
                return AttributedStringFormatter.factorial(calculatorFunction.rawValue).formattedAttributedString
            case .logBaseTen:
                return AttributedStringFormatter.logFunction(
                    AttributedStringFormatter.logFunctionText("log"),
                    AttributedStringFormatter.logFunctionBase("10")).formattedAttributedString
            case .logBaseTwo:
                return AttributedStringFormatter.logFunction(
                    AttributedStringFormatter.logFunctionText("log"),
                    AttributedStringFormatter.logFunctionBase("2")).formattedAttributedString
            case .logBaseY:
                return AttributedStringFormatter.logFunction(
                    AttributedStringFormatter.logFunctionText("log"),
                    AttributedStringFormatter.logFunctionBase("y")).formattedAttributedString
            case .naturalLog:
                return AttributedStringFormatter.logFunctionText("ln").formattedAttributedString
            case .memoryClear,
                    .memoryMinus,
                    .memoryPlus,
                    .memoryRecall:
                return AttributedStringFormatter.memoryRecall(calculatorFunction.rawValue).formattedAttributedString
            case .addition,
                    .division,
                    .multiplication,
                    .subtraction:
                return AttributedStringFormatter._operator(calculatorFunction.rawValue).formattedAttributedString
            case .closingParenthesis,
                    .openingParenthesis:
                return AttributedStringFormatter.parenthesis(calculatorFunction.rawValue).formattedAttributedString
            case .percent:
                return AttributedStringFormatter.percentageFunction(calculatorFunction.rawValue).formattedAttributedString
            case .reciprocal:
                return AttributedStringFormatter.reciprocalFunction(
                    AttributedStringFormatter.reciprocalNumerator("¹"),
                    AttributedStringFormatter.reciprocalSolidus("⁄"),
                    AttributedStringFormatter.reciprocalDenominator("x")).formattedAttributedString
            case .coefficientThreeRadicandX:
                return AttributedStringFormatter.rootFunction(
                    AttributedStringFormatter.rootFunctionCoefficient("3"),
                    AttributedStringFormatter.rootFunctionRadicand("x")).formattedAttributedString
            case .coefficientTwoRadicandX:
                return AttributedStringFormatter.rootFunction(
                    AttributedStringFormatter.rootFunctionCoefficient("2"),
                    AttributedStringFormatter.rootFunctionRadicand("x")).formattedAttributedString
            case .coefficientYRadicandX:
                return AttributedStringFormatter.rootFunction(
                    AttributedStringFormatter.rootFunctionCoefficient("ʸ"),
                    AttributedStringFormatter.rootFunctionRadicandY("x")).formattedAttributedString
            case .degrees,
                .radians:
                return AttributedStringFormatter.siUnit(calculatorFunction.rawValue).formattedAttributedString
            case .signChange:
                return AttributedStringFormatter.toggleNumberSign(
                    AttributedStringFormatter.toggleNumberSignPlus("⁺"),
                    AttributedStringFormatter.toggleNumberSignSolidus("⁄"),
                    AttributedStringFormatter.toggleNumberSignMinust("₋")).formattedAttributedString
            case .secondFunction:
                return AttributedStringFormatter.toggleSecondSetOfFunctions(
                    AttributedStringFormatter.toggleSecondSetOfFunctionsText("2"),
                    AttributedStringFormatter.toggleSecondSetOfFunctionsSuperscript("nd")).formattedAttributedString
                case .hyperbolicCosine,
                    .hyperbolicSine,
                    .hyperbolicTangent:
                return AttributedStringFormatter.trigonometricFunctionText(calculatorFunction.rawValue).formattedAttributedString
            case .inverseHyperbolicCosine:
                return AttributedStringFormatter.trigonometricFunction(
                    AttributedStringFormatter.trigonometricFunctionText("cosh"),
                    AttributedStringFormatter.trigonometricFunctionInverseExponent("-1")).formattedAttributedString
            case .inverseHyperbolicSine:
                return AttributedStringFormatter.trigonometricFunction(
                    AttributedStringFormatter.trigonometricFunctionText("sinh"),
                    AttributedStringFormatter.trigonometricFunctionInverseExponent("-1")).formattedAttributedString
            case .inverseHyperbolicTangent:
                return AttributedStringFormatter.trigonometricFunction(
                    AttributedStringFormatter.trigonometricFunctionText("tanh"),
                    AttributedStringFormatter.trigonometricFunctionInverseExponent("-1")).formattedAttributedString
            case .inverseRightAngleCosine:
                return AttributedStringFormatter.trigonometricFunction(
                    AttributedStringFormatter.trigonometricFunctionText("cos"),
                    AttributedStringFormatter.trigonometricFunctionInverseExponent("-1")).formattedAttributedString
            case .inverseRightAngleSine:
                return AttributedStringFormatter.trigonometricFunction(
                    AttributedStringFormatter.trigonometricFunctionText("sin"),
                    AttributedStringFormatter.trigonometricFunctionInverseExponent("-1")).formattedAttributedString
            case .inverseRightAngleTangent:
                return AttributedStringFormatter.trigonometricFunction(
                    AttributedStringFormatter.trigonometricFunctionText("tan"),
                    AttributedStringFormatter.trigonometricFunctionInverseExponent("-1")).formattedAttributedString
            case .rightAngleCosine,
                    .rightAngleSine,
                    .rightAngleTangent:
                return AttributedStringFormatter.trigonometricFunctionText(calculatorFunction.rawValue).formattedAttributedString
        }
        }
        }
        
        private struct StandardCalculator {
            enum AttributedStringFormatter {
                case clearType(String)
                case decimal(String)
                case digit(String)
                case equal(String)
                case _operator(String)
                case percentageFunction(String)
                case toggleNumberSignMinus(String)
                case toggleNumberSignPlus(String)
                case toggleNumberSignSolidus(String)
                indirect case toggleNumberSign(AttributedStringFormatter, AttributedStringFormatter, AttributedStringFormatter)

                //MARK: - NSAttributedString.Key's

                var baselineOffset: NSNumber { return 0 }
                var fontName: String {
                    switch UITraitCollection.current.legibilityWeight {
                    case .bold:
                        return CustomFont.SFProDisplay.medium.rawValue
                    default:
                        return CustomFont.SFProDisplay.regular.rawValue
                    }
                }
                var fontSize: CGFloat {
                    switch self {
                    case ._operator:
                        return 45
                    default:
                        return 40
                    }
                }
                var font: UIFont! {
                    let name: String = self.fontName
                    let size: CGFloat = self.fontSize
                    guard let font = UIFont(name: name, size: size) else { fatalError("Cannot access \(name) font") }
                    return font
                }
                var kern: Int {
                    switch self {
                    default:
                        return 0
                    }
                }
                func range(length: Int) -> NSRange {
                    return NSRange(location: 0, length: length)
                }
                
                //MARK: - Part/Whole Attributed String Value
                
                var formattedAttributedString: NSAttributedString {
                    switch self {
                    case .clearType(let string):
                        return formatString(for: string)
                    case .decimal(let string):
                        return formatString(for: string)
                    case .digit(let string):
                        return formatString(for: string)
                    case .equal(let string):
                        return formatString(for: string)
                    case ._operator(let string):
                        return formatString(for: string)
                    case .percentageFunction(let string):
                        return formatString(for: string)
                    case .toggleNumberSignMinus(let string):
                        return formatString(for: string)
                    case .toggleNumberSignPlus(let string):
                        return formatString(for: string)
                    case .toggleNumberSignSolidus(let string):
                        return formatString(for: string)
                    case .toggleNumberSign(let plusSign, let solidus, let minusSign):
                        let mutableAttributedString = NSMutableAttributedString()
                        
                        mutableAttributedString.append(plusSign.formattedAttributedString)
                        mutableAttributedString.append(solidus.formattedAttributedString)
                        mutableAttributedString.append(minusSign.formattedAttributedString)
                        
                        return mutableAttributedString
                    }
                }
                
                func formatString(for string: String) -> NSMutableAttributedString {
                    let mutableAttributedString = NSMutableAttributedString(string: string)
                    
                    let range = self.range(length: string.count)
                    
                    mutableAttributedString.addAttributes([NSAttributedString.Key.baselineOffset : self.baselineOffset], range: range)
                    mutableAttributedString.addAttributes([NSAttributedString.Key.kern : self.kern], range: range)
                    mutableAttributedString.addAttributes([NSAttributedString.Key.font : self.font!], range: range)
                
                    return mutableAttributedString
                }
            }
            
            static func attributedString(calculatorFunction: CalculatorFunction) -> NSAttributedString? {
                switch calculatorFunction {
                case .allClear,
                     .clearEntry:
                    return AttributedStringFormatter.clearType(calculatorFunction.rawValue).formattedAttributedString
                case .decimal:
                    return AttributedStringFormatter.decimal(calculatorFunction.rawValue).formattedAttributedString
                case .zero,
                     .one,
                     .two,
                     .three,
                     .four,
                     .five,
                     .six,
                     .seven,
                     .eight,
                     .nine:
                    return AttributedStringFormatter.digit(calculatorFunction.rawValue).formattedAttributedString
                case .result:
                    return AttributedStringFormatter.equal(calculatorFunction.rawValue).formattedAttributedString
                case .addition,
                     .division,
                     .multiplication,
                     .subtraction:
                    return AttributedStringFormatter._operator(calculatorFunction.rawValue).formattedAttributedString
                case .percent:
                    return AttributedStringFormatter.percentageFunction(calculatorFunction.rawValue).formattedAttributedString
                case .signChange:
                    return AttributedStringFormatter.toggleNumberSign(
                        AttributedStringFormatter.toggleNumberSignPlus("⁺"),
                        AttributedStringFormatter.toggleNumberSignSolidus("⁄"),
                        AttributedStringFormatter.toggleNumberSignMinus("₋")
                    ).formattedAttributedString
                default:
                    return nil
//                    fatalError("Could not return attributed string for standard calculator function")
                }
            }
        }
        
        // MARK: - Methods
        
        static func attributedString(for calculatorFunction: CalculatorFunction, calculator: Calculator) -> NSAttributedString? {
            switch calculator {
            case .scientific:
                return ScientificCalculator.attributedString(calculatorFunction: calculatorFunction)
            case .standard:
                return StandardCalculator.attributedString(calculatorFunction: calculatorFunction)
            }
        }
    }
    
    struct CalculatorDisplayNumberLabel {
        private struct ContentSizeFontSizeIncreaseNumber {
            static let extraSmall = -2
            static let small = -1
            static let medium = 0
            static let unspecified = 0
            static let accessibilityMedium = 0
            static let large = 1
            static let extraLarge = 2
            static let extraExtraLarge = 3
            static let extraExtraExtraLarge = 4
            static let accessibilityLarge = 2
            static let accessibilityExtraLarge = 4
            static let accessibilityExtraExtraLarge = 6
            static let accessibilityExtraExtraExtraLarge = 8
        }
        
        func fontName(for calculator: Calculator) -> String {
            switch (calculator, UITraitCollection.current.legibilityWeight) {
            case (.scientific, .bold):
                return CustomFont.SFProDisplay.regular.rawValue
            case (.scientific, .regular):
                return CustomFont.SFProDisplay.regular.rawValue
            case (.scientific, .unspecified):
                return CustomFont.SFProDisplay.regular.rawValue
            case (.standard, .bold):
                return CustomFont.SFProDisplay.regular.rawValue
            case (.standard, .regular):
                return CustomFont.SFProDisplay.thin.rawValue
            case (.standard, .unspecified):
                return CustomFont.SFProDisplay.thin.rawValue
            case (_, _):
                fatalError("Unknown case for output label font type found.")
            }
        }
        func fontSize(for calculator: Calculator) -> CGFloat {
            switch calculator {
            case .scientific:
                return 45
            case .standard:
                return 95
            }
        }
        func font(for calculator: Calculator) -> UIFont {
            let name: String = self.fontName(for: calculator)
            let size: CGFloat = self.fontSize(for: calculator)
            guard let font = UIFont(name: name, size: size) else { fatalError("Cannot access \(name) font") }
            return font
        }

        func attributedString(from text: String, for calcultor: Calculator) -> NSAttributedString {
            let font = self.font(for: calcultor)
            let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : font])
            return attributedString
        }
//
//        func attributedString(from text: String, frame: CGRect) -> NSMutableAttributedString {
//            let mutableAttributedString = NSMutableAttributedString(string: text)
//
//            let range = NSRange(location: 0, length: text.count)
//            let attributes: [NSMutableAttributedString.Key: Any] = [
//                NSMutableAttributedString.Key.font: self.font!,
//            ]
//            mutableAttributedString.setAttributes(attributes, range: range)
//            return mutableAttributedString
//        }
    }
    
    struct SIUnitLabel {
        
        private struct ContentSizeFontSizeIncreaseNumber {
            static let extraSmall = -2
            static let small = -1
            static let medium = 0
            static let unspecified = 0
            static let accessibilityMedium = 0
            static let large = 1
            static let extraLarge = 2
            static let extraExtraLarge = 3
            static let extraExtraExtraLarge = 4
            static let accessibilityLarge = 2
            static let accessibilityExtraLarge = 4
            static let accessibilityExtraExtraLarge = 6
            static let accessibilityExtraExtraExtraLarge = 8
        }
        
        var fontName: String {
            switch UITraitCollection.current.legibilityWeight {
            case .bold:
                return "SFProDisplay-Regular"
            default:
                return "SFProDisplay-Thin"
            }
        }
        var fontSize: CGFloat {
            return 15
        }
        var font: UIFont! {
            let name: String = self.fontName
            let size: CGFloat = self.fontSize
            guard let font = UIFont(name: name, size: size) else { fatalError("Cannot access \(name) font") }
            return font
        }

        func attributedString(from text: String) -> NSAttributedString {
            let font = self.font
            let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : font!])
            return attributedString
        }
    }
    
    static let outputLabel = CalculatorDisplayNumberLabel()
    static let siUnitLabel = SIUnitLabel()
    let calculatorFunction = CalculatorCollectionViewCellLabel()
}


class AttributedString: NSMutableAttributedString {
    
    override init(string str: String) {
        super.init(string: str)
    }
    
    override init(string str: String, attributes attrs: [NSAttributedString.Key : Any]? = nil) {
        super.init(string: str, attributes: attrs)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(in rect: CGRect) {
        super.draw(in: rect)
    }
    
    override func draw(at point: CGPoint) {
        super.draw(at: point)
    }
    
    override func draw(with rect: CGRect, options: NSStringDrawingOptions = [], context: NSStringDrawingContext?) {
        super.draw(with: rect, options: options, context: context        )
    }
    
    override func boundingRect(with size: CGSize, options: NSStringDrawingOptions = [], context: NSStringDrawingContext?) -> CGRect {
        super.boundingRect(with: size, options: options, context: context)
    }
}

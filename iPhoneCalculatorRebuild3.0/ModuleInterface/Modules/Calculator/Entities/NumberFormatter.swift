//
//  NumberFormatter.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import Foundation

struct CalculatorDisplayNumberFormatter {

    // MARK: - Models

    private struct ScientificCalculator {
        
        // MARK: - Models
        
        class CustomNumberFormatter: NumberFormatter {

             //MARK: - Properties

             var decimalMaximum: Double = 9999999999999978
             var decimalMinimum: Double = -9999999999999978
             var decimalDigitMaximum: Int = 16

             //MARK: - Init

             override init() {
                 super.init()
                 self.exponentSymbol = "e"
                 self.negativeInfinitySymbol = "Error"
                 self.negativePrefix = "−"
                 self.nilSymbol = "Error"
                 self.notANumberSymbol = "Error"
                 self.positiveInfinitySymbol = "Error"
             }

             required init?(coder: NSCoder) {
                 fatalError("init(coder:) has not been implemented")
             }

             //MARK: - Methods

             func updateProperties(for number: NSNumber, integerDigits: Int, fractionDigits: Int) {
                 let doubleValue = number.doubleValue

                 //Floatcheck - Mainly for when the percentage function gets pressed repeatedly
                 let useScientificNotationForFloat: Bool = {
                     let floatValue = number.floatValue
                     let string: String! = String(floatValue.magnitude)
                     let substring = string.split(separator: "e")
                     if substring.count > 1 {
                         let string = substring[1]
                         let double: Int! = Int(string)
                         self.usesSignificantDigits = true
                         let magnitudeLimit: Int = -self.decimalDigitMaximum - integerDigits
                         return double < magnitudeLimit
                     }
                     return false
                 }()

                 //ScientificNotation
                 if doubleValue < self.decimalMinimum || doubleValue > self.decimalMaximum || useScientificNotationForFloat {
                     self.numberStyle = .scientific
                     self.usesGroupingSeparator = false
                     self.usesSignificantDigits = true
                 }

                 //decimal
                 else {
                     self.maximumIntegerDigits = integerDigits < self.decimalDigitMaximum ? integerDigits : self.decimalDigitMaximum

                     let availableDigits: Int = self.decimalDigitMaximum
                     self.maximumFractionDigits = availableDigits < fractionDigits ? availableDigits : fractionDigits
                     self.minimumFractionDigits = availableDigits < fractionDigits ? availableDigits : fractionDigits
                     self.numberStyle = .decimal
                     self.usesGroupingSeparator = true
                     self.usesSignificantDigits = false
                 }
             }
     }
        
        static let numberFormatter = CustomNumberFormatter()
        
        static func formatTermNumber(term: TermProtocol) -> String {
            guard let double = term.doubleValue else { return numberFormatter.string(for: nil)! }
            let number = NSNumber(value: double)

            switch term.termType {
            case .mutableNumber:
                let mutableNumberValue = term as! MutableNumber
                numberFormatter.updateProperties(for: number, integerDigits: mutableNumberValue.integerArray.count, fractionDigits: mutableNumberValue.fractionArray.count)
                
                let formattedNumberString: String! = {
                    var string: String! = self.numberFormatter.string(for: number)
                    
                    if mutableNumberValue.fractionArray.count == 0 && mutableNumberValue.decimalAdded {
                        string += CalculatorFunction.decimal.rawValue
                    }
                    
                    return string
                }()
                
                return formattedNumberString
            default:
                let numberString: String = number.stringValue
                let numberSubstring: [Substring] = numberString.split(separator: ".")

                let integerDigits: Int = numberSubstring[0].count
                let fractionDigits: Int = {
                    guard numberSubstring.count > 1 else { return 0 }
                    return numberSubstring[1].count
                }()

                self.numberFormatter.updateProperties(for: number, integerDigits: integerDigits, fractionDigits: fractionDigits)

                var formattedNumberString: String! = self.numberFormatter.string(for: number)

                //Avoid 9.200000000000000
                if formattedNumberString.contains(".") {
                    let reversedFormattedNumberString = formattedNumberString.reversed()
                    for char in reversedFormattedNumberString {
                        if char == "0" {
                            formattedNumberString.removeLast()
                        }
                        else if char == "." {
                            formattedNumberString.removeLast()
                            return formattedNumberString
                        }
                        else {
                            return formattedNumberString
                        }
                    }
                }

                return formattedNumberString
            }
        }
    }
    private struct StandardCalculator {

        // MARK: - Models

        class CustomNumberFormatter: NumberFormatter {

            //MARK: - Properties

            var decimalMaximum: Double = 999999999
            var decimalMinimum: Double = -999999999
            var decimalDigitMaximum: Int = 9

            //MARK: - Init

            override init() {
                super.init()
                self.exponentSymbol = "e"
                self.negativeInfinitySymbol = "Error"
                self.negativePrefix = "−"
                self.nilSymbol = "Error"
                self.notANumberSymbol = "Error"
                self.positiveInfinitySymbol = "Error"
            }

            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            //MARK: - Methods

            func updateProperties(for number: NSNumber, integerDigits: Int, fractionDigits: Int) {
                let doubleValue = number.doubleValue

                //Floatcheck - Mainly for when the percentage function gets pressed repeatedly
                let useScientificNotationForFloat: Bool = {
                    let floatValue = number.floatValue
                    let string: String! = String(floatValue.magnitude)
                    let substring = string.split(separator: "e")
                    if substring.count > 1 {
                        let string = substring[1]
                        let double: Int! = Int(string)
                        self.usesSignificantDigits = true
                        let magnitudeLimit: Int = -self.decimalDigitMaximum - integerDigits
                        return double < magnitudeLimit
                    }
                    return false
                }()

                //ScientificNotation
                if doubleValue < self.decimalMinimum || doubleValue > self.decimalMaximum || useScientificNotationForFloat {
                    self.numberStyle = .scientific
                    self.usesGroupingSeparator = false
                    self.usesSignificantDigits = true
                }

                //decimal
                else {
                    self.maximumIntegerDigits = integerDigits < self.decimalDigitMaximum ? integerDigits : self.decimalDigitMaximum

                    let availableDigits: Int = self.decimalDigitMaximum
                    self.maximumFractionDigits = availableDigits < fractionDigits ? availableDigits : fractionDigits
                    self.minimumFractionDigits = availableDigits < fractionDigits ? availableDigits : fractionDigits
                    self.numberStyle = .decimal
                    self.usesGroupingSeparator = true
                    self.usesSignificantDigits = false
                }
            }
        }

        // MARK: - Properties

        static let numberFormatter = CustomNumberFormatter()

        // MARK: - Methods

        static func formatTermNumber(term: TermProtocol) -> String {
            // GET DOUBLE OR RETURN ERROR
            guard let doubleValue = term.doubleValue else { return numberFormatter.string(for: nil)! }
            // GET NSNUMBER
            let number = NSNumber(value: doubleValue)

            switch term.termType {
            case .mutableNumber:
                guard let mutableNumber = term as? MutableNumber else { fatalError() }
                // GET INTEGER AND  DECIMAL DIGITS
                // AND UPDATE NUMBER FORMATTER
                self.numberFormatter.updateProperties(for: number, integerDigits: mutableNumber.integerArray.count, fractionDigits: mutableNumber.fractionArray.count)

                let formattedNumberString: String! = {
                    // GET FORMATTED NUMBER
                    var string: String! = self.numberFormatter.string(for: number)
                    // ADD DECIMAL
                    if mutableNumber.fractionArray.count == 0 && mutableNumber.decimalAdded {
                        string += CalculatorFunction.decimal.rawValue
                    }
                    return string
                }()
                return formattedNumberString
            default:
                // GET INTEGER AND DECIMAL DIGITS
                // GET STRING
                let numberString: String = number.stringValue
                // GET SUB . STRINGS
                let numberSubstring: [Substring] = numberString.split(separator: ".")
                
                let integerDigits: Int = numberSubstring[0].count

                let fractionDigits: Int = {
                    guard numberSubstring.count > 1 else { return 0 }
                    return numberSubstring[1].count
                }()
                // AND UPDATE NUMBER FORMATTER
                self.numberFormatter.updateProperties(for: number, integerDigits: integerDigits, fractionDigits: fractionDigits)
                // GET FORMATTED NUMBER AND AVOID EXTRA ZEROES
                var formattedNumberString: String! = self.numberFormatter.string(for: number)

                //Avoid 9.200000000000000
                if formattedNumberString.contains(".") {
                    let reversedFormattedNumberString = formattedNumberString.reversed()
                    for char in reversedFormattedNumberString {
                        if char == "0" {
                            formattedNumberString.removeLast()
                        }
                        else if char == "." {
                            formattedNumberString.removeLast()
                            return formattedNumberString
                        }
                        else {
                            return formattedNumberString
                        }
                    }
                }
                return formattedNumberString
            }
        }
    }

    // MARK: - Method

    static func string(from term: TermProtocol, calculator: Calculator) -> String! {
        let string: String! = {
            switch calculator {
            case .scientific:
                return ScientificCalculator.formatTermNumber(term: term)
            case .standard:
                return StandardCalculator.formatTermNumber(term: term)
            }
        }()
        
        return string
    }
}

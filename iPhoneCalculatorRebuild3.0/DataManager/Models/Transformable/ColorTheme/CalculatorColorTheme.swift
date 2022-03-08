//
//  CalculatorColorTheme.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 11/17/21.
//

import UIKit

typealias ColorThemeSection = CalculatorColorTheme.Section.Key
typealias ColorThemeSectionObject = CalculatorColorTheme.Section.CalculatorFunctionColor.Key

protocol CalculatorFunctionColorProtocol {
    var backgroundColor: UIColor { get set }
    var textColor: UIColor { get set }
    var alternateBackgroundColor: UIColor? { get set }
    var alternateTextColor: UIColor? { get set }
}

public class CalculatorColorTheme: NSObject, NSSecureCoding {
    
    // MARK: - Models
    
    @objc(CalculatorColorThemePersistedDataModel_Color)class Section: NSObject, NSSecureCoding {

        // MARK: - Models
        
        @objc(CalculatorColorThemePersistedDataModel_CalculatorBackground)class CalculatorBackground: NSObject, NSSecureCoding {
            
            // MARK: - Properties

            var backgroundColor: UIColor
            
            // MARK: - Init
            
            override init() {
                self.backgroundColor = .clear
            }
            
            // MARK: - Transforming
            
            enum Key: String {
                case backgroundColor
            }
            
            public static var supportsSecureCoding: Bool = true

            public required init?(coder: NSCoder) {
                self.backgroundColor = {
                    guard let data = coder.decodeObject(of: UIColor.self, forKey: Key.backgroundColor.rawValue) else { fatalError() }
                    return data
                }()
            }
            
            public func encode(with coder: NSCoder) {
                coder.encode(self.backgroundColor, forKey: Key.backgroundColor.rawValue)
            }
        }
        @objc(CalculatorColorThemePersistedDataModel_CalculatorDisplay)class CalculatorDisplayColor: NSObject, NSSecureCoding {
            
            // MARK: - Properties
            
            var textColor: UIColor
            var backgroundColor: UIColor
            
            // MARK: - Init
            
            override init() {
                self.backgroundColor = .clear
                self.textColor = .clear
            }
            
            // MARK: - Transforming
            
            enum Key: String {
                case backgroundColor
                case textColor
            }
            
            public static var supportsSecureCoding: Bool = true

            public required init?(coder: NSCoder) {
                self.backgroundColor = {
                    guard let data = coder.decodeObject(of: UIColor.self, forKey: Key.backgroundColor.rawValue) else { fatalError() }
                    return data
                }()
                self.textColor = {
                    guard let data = coder.decodeObject(of: UIColor.self, forKey: Key.textColor.rawValue) else { fatalError() }
                    return data
                }()
            }
            
            public func encode(with coder: NSCoder) {
                coder.encode(self.backgroundColor, forKey: Key.backgroundColor.rawValue)
                coder.encode(self.textColor, forKey: Key.textColor.rawValue)
            }
        }
        @objc(CalculatorColorThemePersistedDataModel_CalculatorFunctionsSection0)class CalculatorFunctionColor: NSObject, NSSecureCoding, CalculatorFunctionColorProtocol {
            
            // MARK: - Properties
            
            var backgroundColor: UIColor
            var textColor: UIColor
            var alternateBackgroundColor: UIColor?
            var alternateTextColor: UIColor?
            
            // MARK: - Init
            
            override init() {
                self.backgroundColor = .clear
                self.textColor = .clear
            }
            
            // MARK: - Transforming
            
            enum Key: String {
                case alternateBackgroundColor
                case alternateTextColor
                case backgroundColor
                case textColor
            }
            
            public static var supportsSecureCoding: Bool = true

            public required init?(coder: NSCoder) {
                self.backgroundColor = {
                    guard let data = coder.decodeObject(of: UIColor.self, forKey: Key.backgroundColor.rawValue) else { fatalError() }
                    return data
                }()
                self.textColor = {
                    guard let data = coder.decodeObject(of: UIColor.self, forKey: Key.textColor.rawValue) else { fatalError() }
                    return data
                }()
                self.alternateBackgroundColor = {
                    let data = coder.decodeObject(of: UIColor.self, forKey: Key.alternateBackgroundColor.rawValue)
                    return data
                }()
                self.alternateTextColor = {
                    let data = coder.decodeObject(of: UIColor.self, forKey: Key.alternateTextColor.rawValue)
                    return data
                }()
            }
            
            public func encode(with coder: NSCoder) {
                coder.encode(self.backgroundColor, forKey: Key.backgroundColor.rawValue)
                coder.encode(self.textColor, forKey: Key.textColor.rawValue)
                coder.encode(self.alternateBackgroundColor, forKey: Key.alternateBackgroundColor.rawValue)
                coder.encode(self.alternateTextColor, forKey: Key.alternateTextColor.rawValue)
            }
        }
        
        // MARK: - Properties
        
        var calculatorBackground: CalculatorBackground
        var calculatorDisplay: CalculatorDisplayColor
        var calculatorFunctionSection0: CalculatorFunctionColor
        var calculatorFunctionSection1: CalculatorFunctionColor
        var calculatorFunctionSection2: CalculatorFunctionColor
        var calculatorFunctionSection3: CalculatorFunctionColor
        
        // MARK: - Init
        
        override init() {
            self.calculatorBackground = CalculatorBackground()
            self.calculatorDisplay = CalculatorDisplayColor()
            self.calculatorFunctionSection0 = CalculatorFunctionColor()
            self.calculatorFunctionSection1 = CalculatorFunctionColor()
            self.calculatorFunctionSection2 = CalculatorFunctionColor()
            self.calculatorFunctionSection3 = CalculatorFunctionColor()
        }
        
        // MARK: - Methods
        
        func sectionColors(for calculatorFunction: CalculatorFunction) -> CalculatorFunctionColorProtocol {
            let functionCategory: CalculatorFunction.FunctionCategory! = .init(calculatorFunction: calculatorFunction)
            switch functionCategory {
            case .digit, .decimal:
                return self.calculatorFunctionSection2
            case .entryClearer, .toggleNumberSign, .percentageFunction:
                return self.calculatorFunctionSection1
            case .basicOperator, .result:
                return self.calculatorFunctionSection3
            default:
                return self.calculatorFunctionSection0
            }
        }
        
        // MARK: - Transforming
        
        enum Key: String {
            case calculatorBackground
            case calculatorDisplay
            case calculatorFunctionSection0
            case calculatorFunctionSection1
            case calculatorFunctionSection2
            case calculatorFunctionSection3
        }
        
        public static var supportsSecureCoding: Bool = true

        public required init?(coder: NSCoder) {
            self.calculatorBackground = {
                guard let data = coder.decodeObject(of: CalculatorBackground.self, forKey: Key.calculatorBackground.rawValue) else { fatalError() }
                return data
            }()
            self.calculatorDisplay = {
                guard let data = coder.decodeObject(of: CalculatorDisplayColor.self, forKey: Key.calculatorDisplay.rawValue) else { fatalError() }
                return data
            }()
            self.calculatorFunctionSection0 = {
                guard let data = coder.decodeObject(of: CalculatorFunctionColor.self, forKey: Key.calculatorFunctionSection0.rawValue) else { fatalError() }
                return data
            }()
            self.calculatorFunctionSection1 = {
                guard let data = coder.decodeObject(of: CalculatorFunctionColor.self, forKey: Key.calculatorFunctionSection1.rawValue) else { fatalError() }
                return data
            }()
            self.calculatorFunctionSection2 = {
                guard let data = coder.decodeObject(of: CalculatorFunctionColor.self, forKey: Key.calculatorFunctionSection2.rawValue) else { fatalError() }
                return data
            }()
            self.calculatorFunctionSection3 = {
                guard let data = coder.decodeObject(of: CalculatorFunctionColor.self, forKey: Key.calculatorFunctionSection3.rawValue) else { fatalError() }
                return data
            }()
        }
        
        public func encode(with coder: NSCoder) {
            coder.encode(self.calculatorBackground, forKey: Key.calculatorBackground.rawValue)
            coder.encode(self.calculatorDisplay, forKey: Key.calculatorDisplay.rawValue)
            coder.encode(self.calculatorFunctionSection0, forKey: Key.calculatorFunctionSection0.rawValue)
            coder.encode(self.calculatorFunctionSection1, forKey: Key.calculatorFunctionSection1.rawValue)
            coder.encode(self.calculatorFunctionSection2, forKey: Key.calculatorFunctionSection2.rawValue)
            coder.encode(self.calculatorFunctionSection3, forKey: Key.calculatorFunctionSection3.rawValue)
        }
    }
    
    // MARK: - AccessibleThemes
    
    static let iPhone: CalculatorColorTheme = {
        let colorTheme = CalculatorColorTheme()
        
        colorTheme.title = "iPhone"
        colorTheme.isActive = true
        
        colorTheme.section.calculatorBackground.backgroundColor = .black
        
        colorTheme.section.calculatorDisplay.backgroundColor = .clear
        colorTheme.section.calculatorDisplay.textColor = .white
        
        colorTheme.section.calculatorFunctionSection0.alternateBackgroundColor = .lightGray
        colorTheme.section.calculatorFunctionSection0.alternateTextColor = .black
        colorTheme.section.calculatorFunctionSection0.backgroundColor = .eerieBlackish
        colorTheme.section.calculatorFunctionSection0.textColor = .white
        
        colorTheme.section.calculatorFunctionSection1.backgroundColor = .lightGray
        colorTheme.section.calculatorFunctionSection1.textColor = .black
        
        colorTheme.section.calculatorFunctionSection2.backgroundColor = .darkLiverish
        colorTheme.section.calculatorFunctionSection2.textColor = .white

        colorTheme.section.calculatorFunctionSection3.alternateBackgroundColor = .white
        colorTheme.section.calculatorFunctionSection3.alternateTextColor = .vividGambogeish
        colorTheme.section.calculatorFunctionSection3.backgroundColor = .vividGambogeish
        colorTheme.section.calculatorFunctionSection3.textColor = .white
        
        return colorTheme
    }()
    static let datafetching: CalculatorColorTheme = {
        let colorTheme = CalculatorColorTheme()
        
        colorTheme.isActive = false
        
        colorTheme.title = "Datafetching"
        
        colorTheme.section.calculatorBackground.backgroundColor = .orange
        
        colorTheme.section.calculatorDisplay.backgroundColor = .red
        colorTheme.section.calculatorDisplay.textColor = .purple
        
        colorTheme.section.calculatorFunctionSection0.alternateBackgroundColor = .black
        colorTheme.section.calculatorFunctionSection0.alternateTextColor = .lightGray
        colorTheme.section.calculatorFunctionSection0.backgroundColor = .yellow
        colorTheme.section.calculatorFunctionSection0.textColor = .orange
        
        colorTheme.section.calculatorFunctionSection1.backgroundColor = .blue
        colorTheme.section.calculatorFunctionSection1.textColor = .red
        
        colorTheme.section.calculatorFunctionSection3.backgroundColor = .purple
        colorTheme.section.calculatorFunctionSection3.textColor = .systemPink

        colorTheme.section.calculatorFunctionSection3.alternateBackgroundColor = .white
        colorTheme.section.calculatorFunctionSection3.alternateTextColor = .vividGambogeish
        colorTheme.section.calculatorFunctionSection3.backgroundColor = .cyan
        colorTheme.section.calculatorFunctionSection3.textColor = .blue
        
        return colorTheme
    }()
    static var active: CalculatorColorTheme = CalculatorColorTheme.iPhone

    // MARK: - Properties
    
    var section: Section
    var createDate: NSDate
    var isActive: Bool
    var modifiedDate: NSDate
    var title: NSString
    var uuid: UUID
    
    // MARK: - Init
    
    override init() {
        let now = NSDate()
        
        self.section = Section()
        self.createDate = now
        self.isActive = false
        self.modifiedDate = now
        self.title = ""
        self.uuid = UUID()
    }
    
    // MARK: - Transforming
    
    enum Key: String {
        case color
        case createDate
        case isActive
        case modifiedDate
        case title
        case uuid
    }
    
    public static var supportsSecureCoding: Bool = true

    public required init?(coder: NSCoder) {
        self.section = {
            guard let data = coder.decodeObject(of: Section.self, forKey: Key.color.rawValue) else { fatalError() }
            return data
        }()
        self.createDate = {
            guard let data = coder.decodeObject(of: NSDate.self, forKey: Key.createDate.rawValue) else { fatalError() }
            return data
        }()
        self.isActive = {
            guard let data = coder.decodeObject(of: NSNumber.self, forKey: Key.isActive.rawValue) else { fatalError() }
            return data.boolValue
        }()
        self.modifiedDate = {
            guard let data = coder.decodeObject(of: NSDate.self, forKey: Key.modifiedDate.rawValue) else { fatalError() }
            return data
        }()
        self.title = {
            guard let data = coder.decodeObject(of: NSString.self, forKey: Key.title.rawValue) else { fatalError() }
            return data
        }()
        self.uuid = {
            guard let data = coder.decodeObject(of: NSString.self, forKey: Key.uuid.rawValue) else { fatalError() }
            return UUID(uuidString: data.string)!
        }()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.section, forKey: Key.color.rawValue)
        coder.encode(self.createDate, forKey: Key.createDate.rawValue)
        coder.encode(self.isActive.number, forKey: Key.isActive.rawValue)
        coder.encode(self.modifiedDate, forKey: Key.modifiedDate.rawValue)
        coder.encode(self.title, forKey: Key.title.rawValue)
        coder.encode(self.uuid.uuidString.nsString, forKey: Key.uuid.rawValue)
    }
}


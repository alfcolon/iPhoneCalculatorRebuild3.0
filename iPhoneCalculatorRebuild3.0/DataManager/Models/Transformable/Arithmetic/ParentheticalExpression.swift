//
//  ParentheticalExpression.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import Foundation

public class ParentheticalExpression: NSObject, NSSecureCoding, TermProtocol {
    
    // MARK: - Models
        
    enum PrecedenceOperationType: String {
        case low
        case high
    }

    // MARK: - Properties
    
    var low: PrecedenceOperation!
    var high: PrecedenceOperation!
    var reverseParentheticalExpressionContainer: ParentheticalExpressionContainer!
    
    // MARK: - Info
    
    var currentPrecedence: PrecedenceOperationType!
    var currentPrecedenceOperation: PrecedenceOperation {
        return self.currentPrecedence == .high ? self.high : self.low
    }
    var isEmpty: Bool {
        return self.low.isEmpty && self.high.isEmpty
    }
    
    // MARK: - Init
    
    init(container: ParentheticalExpressionContainer, startingTerm: TermProtocol?) {
        self.negateNumber = false
        self.termType = .parentheticalExpression
        self.termTestIdentifier = UUID()
        self.currentPrecedence = .low
        self.reverseParentheticalExpressionContainer = container
        super.init()
        self.low = PrecedenceOperation(reverseTerm: self, leftTerm: startingTerm)
        self.high = PrecedenceOperation(reverseTerm: self)
        
        
    }
    
    // MARK: - Methods
    
    func removeCurrentPrecedenceOperation() -> PrecedenceOperation! {
        switch self.currentPrecedence! {
        case .low:
            let precedenceOperation = self.low
            self.low = PrecedenceOperation(reverseTerm: self)
            return precedenceOperation
        case .high:
            let precedenceOperation = self.high
            self.high = PrecedenceOperation(reverseTerm: self)
            self.currentPrecedence = .low
            return precedenceOperation
        }
    }
    
    func promotePrecedence(basicOperator: CalculatorFunction) {
        guard self.currentPrecedence == .low else { fatalError() }
        guard self.low.isEmpty == false else { return }
        
        let promotetRightTerm: Bool = self.low.rightTerm != nil
        let promoteLeftTermOperationRightTerm: Bool = low.leftTerm?.termType == .operation
        let promoteLeftTerm: Bool = !promotetRightTerm && !promoteLeftTermOperationRightTerm && low.leftTerm != nil
        
        switch true {
        case promotetRightTerm:
            high.leftTerm = low.rightTerm
            low.rightTerm = nil
        case promoteLeftTerm:
            high.leftTerm = low.leftTerm
            low.leftTerm = nil
            low.basicOperator = nil
        case promoteLeftTermOperationRightTerm:
            guard let operation = low.leftTerm as? PrecedenceOperation else { fatalError() }
            
            high.leftTerm = operation.rightTerm
            low.basicOperator = operation.basicOperator
            low.leftTerm = operation.leftTerm
        default: // promote low precedence left term
            fatalError()
        }
        
        self.high.basicOperator = basicOperator
        self.currentPrecedence = .high
    }
    
    func demotePrecedence(basicOperator: CalculatorFunction) {
        guard self.currentPrecedence == .high else { fatalError() }
        guard basicOperator == .addition || basicOperator == .subtraction else { fatalError() }
        
        let demoteHightPrecedenceAsDoubleNumberToLowPrecedenceLeftTerm: Bool = self.low.isEmpty && self.high.rightTerm != nil
        let demoteHightPrecedenceAsDoubleNumberToLowPrecedenceRightTerm: Bool = self.low.leftTerm != nil && self.low.basicOperator != nil && self.high.rightTerm != nil
        let demoteHighPrecedenceLeftTermToLowPrecedenceLeftTerm: Bool = self.low.isEmpty && self.high.rightTerm == nil
        let demoteHighPrecedenceLeftTermToLowPrecedenceRightTerm: Bool = self.low.leftTerm != nil && self.low.basicOperator != nil && self.low.rightTerm == nil && self.high.rightTerm == nil
        
        switch true {
        case demoteHighPrecedenceLeftTermToLowPrecedenceLeftTerm:
            self.low.leftTerm = self.high.leftTerm
        case demoteHighPrecedenceLeftTermToLowPrecedenceRightTerm:
            self.low.rightTerm = self.high.leftTerm
        case demoteHightPrecedenceAsDoubleNumberToLowPrecedenceLeftTerm:
            let doubleNumber = DoubleNumber(term: self.high)
            self.low.leftTerm = doubleNumber
        case demoteHightPrecedenceAsDoubleNumberToLowPrecedenceRightTerm:
            let doubleNumber = DoubleNumber(term: self.high)
            self.low.rightTerm = doubleNumber
        default:
            fatalError()
        }
        self.high = PrecedenceOperation(reverseTerm: self)
        self.low.basicOperator = basicOperator
        self.currentPrecedence = .low
    }
    
    func refactorPrecedenceToLeftTerm(precedence: PrecedenceOperationType, arithmenticOperator: CalculatorFunction) {
        switch precedence {
        case .high:
            guard self.high.leftTerm != nil && self.high.basicOperator != nil && self.high.rightTerm != nil else { fatalError() }
            let doubleNumber = DoubleNumber(term: self.high)
            self.high = PrecedenceOperation(reverseTerm: self, leftTerm: doubleNumber, rightTerm: nil, basicOperator: arithmenticOperator)
        case .low:
            guard self.low.leftTerm != nil && self.low.basicOperator != nil && self.low.rightTerm != nil else { fatalError() }
            
            if let lastLeftTermOperation = low.leftTerm as? PrecedenceOperation {
                low.leftTerm = DoubleNumber(term: lastLeftTermOperation)
            }
            let newLeftTermOperation = self.low
            self.low = PrecedenceOperation(reverseTerm: self, leftTerm: newLeftTermOperation, basicOperator: arithmenticOperator)
        }
    }
    
    func doubleValue(with term: TermProtocol) -> Double? {
        self.currentPrecedenceOperation.add(newTerm: term)
        let doubleValue1 = self.doubleValue
        let _ = self.currentPrecedenceOperation.termForNewParentheticalExpression()
        return doubleValue1
    }
    
    // MARK: - Term Protocol

    var doubleValue: Double? {
        switch self.currentPrecedence! {
        case .high:
            guard let doubleValue = self.high.doubleValue else { return nil }
            guard self.low.isEmpty == false else { return doubleValue }
            self.low.add(newTerm: DoubleNumber(doubleValue: doubleValue))
            fallthrough
        case .low:
            guard let doubleValue = self.low.doubleValue else { return nil }
            return doubleValue
        }
    }
    var negateNumber: Bool
    var termTestIdentifier: UUID
    var termType: Term
    
    // MARK: - Term Protocol

    enum Key: String {
        case high
        case low
        case termType
        case negateNumber
        case termTestIdentifier
        case reverseParentheticalExpressionContainer
        case precedence
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
        self.low = {
            guard let term = coder.decodeObject(of: PrecedenceOperation.self, forKey: Key.low.rawValue) else { fatalError() }
            return term
        }()
        self.high = {
            guard let term = coder.decodeObject(of: PrecedenceOperation.self, forKey: Key.high.rawValue) else { fatalError() }
            return term
        }()
        self.reverseParentheticalExpressionContainer = {
            guard let term = coder.decodeObject(of: ParentheticalExpressionContainer.self, forKey: Key.reverseParentheticalExpressionContainer.rawValue) else { fatalError() }
            return term
        }()
        self.currentPrecedence = {
            guard let nsString = coder.decodeObject(of: NSString.self, forKey: Key.precedence.rawValue) else { fatalError() }
            guard let precedence = PrecedenceOperationType(rawValue: String(nsString)) else { fatalError() }
            return precedence
        }()
        super.init()
        self.low.reverseTerm = self
        self.high.reverseTerm = self
    }
    
    public func encode(with coder: NSCoder) {
        self.encodeTestProtocol(coder: coder)
        coder.encode(self.reverseParentheticalExpressionContainer, forKey: Key.reverseParentheticalExpressionContainer.rawValue)
        coder.encode(self.low!, forKey: Key.low.rawValue)
        coder.encode(self.high!, forKey: Key.high.rawValue)
        coder.encode(NSString(string: self.currentPrecedence.rawValue), forKey: Key.precedence.rawValue)
    }
}

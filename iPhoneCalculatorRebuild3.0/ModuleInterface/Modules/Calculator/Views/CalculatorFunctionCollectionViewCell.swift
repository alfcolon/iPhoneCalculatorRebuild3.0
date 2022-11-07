//
//  CalculatorFunctionCollectionViewCell.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

class CalculatorFunctionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Models
    
    struct Views {
        
        // MARK: - Models
        
        class CalculatorFunctionLabelView: UIView {
            
            // MARK: - Models

            class RadicalSymbolView: UIView {

                // MARK: - Properties

                var attributedString: NSAttributedString
                var strokeColor: CGColor
                var lineWidth: CGFloat
                
                // MARK: - Init
                
                init(strokeColor: UIColor) {
                    self.attributedString = TextFormatter.CalculatorCollectionViewCellLabel.attributedString(for: CalculatorFunction.coefficientTwoRadicandX, calculator: .scientific)!
                    self.strokeColor = strokeColor.cgColor
                    self.lineWidth = 1
                    
                    super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.attributedString.size()))

                    self.translatesAutoresizingMaskIntoConstraints = false
                    self.backgroundColor = .clear

                    NSLayoutConstraint.activate([
                        self.widthAnchor.constraint(equalToConstant: frame.width),
                        self.heightAnchor.constraint(equalToConstant: frame.height),
                    ])
                }

                required init?(coder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }

                override func draw(_ rect: CGRect) {
                    let attributedString = TextFormatter.CalculatorCollectionViewCellLabel.attributedString(for: .coefficientTwoRadicandX, calculator: .scientific)!

                    let xSymbol = attributedString.attributedSubstring(from: NSRange(location: 1, length: 1))
                    let xSymbolCTLine = CTLineCreateWithAttributedString(xSymbol)
                    let xSymbolCTLineImageBounds = CTLineGetImageBounds(xSymbolCTLine, nil)

                    let twoSymbol = attributedString.attributedSubstring(from: NSRange(location: 0, length: 1))
                    let twoSymbolCTline = CTLineCreateWithAttributedString(twoSymbol)
                    let ttwoSymbolCTLineImageBounds = CTLineGetImageBounds(twoSymbolCTline, nil)

                    let topRight: CGPoint = {
                        let x: CGFloat = attributedString.size().width
                        let y: CGFloat = xSymbolCTLineImageBounds.height - self.lineWidth - 2
                        return CGPoint(x: x, y: y)
                    }()
                    let topLeft: CGPoint = {
                        let x: CGFloat = attributedString.size().width - xSymbol.size().width - self.lineWidth
                        let y: CGFloat = topRight.y
                        return CGPoint(x: x, y: y)
                    }()
                    let bottomRight: CGPoint = {
                        let x: CGFloat = xSymbolCTLineImageBounds.maxX - self.lineWidth - 1
                        let y: CGFloat = xSymbolCTLineImageBounds.height * 2 + self.lineWidth
                        return CGPoint(x: x, y: y)
                    }()
                    let bottomLeft: CGPoint = {
                        let x: CGFloat = xSymbolCTLineImageBounds.maxX / 2
                        let y: CGFloat = bottomRight.y
                        return CGPoint(x: x, y: y)
                    }()
                    let hookTop: CGPoint = {
                        let x: CGFloat = 1
                        let y: CGFloat = ttwoSymbolCTLineImageBounds.height * 2 + self.lineWidth
                        return CGPoint(x: x, y: y)
                    }()

                    let context = UIGraphicsGetCurrentContext()
                    context?.setLineWidth(self.lineWidth)
                    context?.setStrokeColor(self.strokeColor)
                    
                    context?.move (to: topRight)
                    context?.addLine (to: topLeft)
                    
                    context?.move (to: topLeft)
                    context?.addLine (to: bottomRight)

                    context?.move (to: bottomRight)
                    context?.addLine (to: bottomLeft)

                    context?.move (to: bottomLeft)
                    context?.addLine (to: hookTop)

                    context?.strokePath()
                }
            }
        
            // MARK: - Properties
            
            var label: UILabel
            var centerXConstraint: NSLayoutConstraint!
            var radicalSymbolView: RadicalSymbolView?
            
            // MARK: - Init
            
            override init(frame: CGRect) {
                self.label = {
                    let label = UILabel(frame: frame)
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.textAlignment = .center
                    return label
                }()
                super.init(frame: frame)
                self.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(self.label)
                self.centerXConstraint = self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
                
                NSLayoutConstraint.activate([
                    self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    self.centerXConstraint
                ])
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            // MARK: - Methods
            
            func addRadicalSymbol(color: UIColor) {
                self.radicalSymbolView = RadicalSymbolView(strokeColor: color)
                self.addSubview(self.radicalSymbolView!)
                NSLayoutConstraint.activate([
                    self.radicalSymbolView!.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    self.radicalSymbolView!.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                ])
            }
            
            func removeRadicalSymbol() {
                self.radicalSymbolView?.removeFromSuperview()
                self.radicalSymbolView = nil
            }
            
            func resetRadicalSymbol(color: UIColor) {
                self.removeRadicalSymbol()
                self.addRadicalSymbol(color: color)
            }
        }
        
        // MARK: - Properties
        
        let backgroundView: UIView = UIView()
        let calculatorFunctionLabelView: CalculatorFunctionLabelView = CalculatorFunctionLabelView()
        let highlightView: UIView = .init()
        let logicAnimationView: UIView = .init()
        
        init(addAndContrainToCell cell: CalculatorFunctionCollectionViewCell) {
            highlightView.translatesAutoresizingMaskIntoConstraints = false
            logicAnimationView.translatesAutoresizingMaskIntoConstraints = false
            cell.backgroundView = backgroundView
            cell.contentView.addAndConstrain(subview: self.highlightView)
            cell.contentView.addAndConstrain(subview: self.calculatorFunctionLabelView)
            cell.contentView.addAndConstrain(subview: self.logicAnimationView)
        }
    }
    
    // MARK: - Properties
    
    static let reuseIdentifier: String = "CalculatorFunctionCell"
    var calculatorFunction: CalculatorFunction?
    var item: Int?
    var presenter: CalculatorPresenterToCalculatorViewProtocol!
    var views: Views!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.views = Views(addAndContrainToCell: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Update

extension CalculatorFunctionCollectionViewCell: CalculatorFunctionCollectionViewCellPresentationProtocol {
    enum Update {
        case data(Data)
        case label(Label.CalculatorFunction)
        case view(View)
        
        enum Data {
            case calculatorFunction(CalculatorFunction)
        }
        enum Label {
            case calculatorFunction(CalculatorFunction)
            
            enum CalculatorFunction {
                case attributedText(NSAttributedString)
                case centerXConstant(CGFloat)
                case textColor(UIColor)
            }
        }
        enum View {
            case background(Background)
            case highlight(Highlight)
            case logicAnimation(LogicAnimation)
            case radicalSymbol(RadicalSymbol)
            
            enum Background {
                case backgroundColor(UIColor)
                case roundCorners
            }
            enum Highlight {
                case animate(toColor: UIColor, options: UIView.AnimationOptions, duration: Double, delay: Double)
            }
            enum LogicAnimation {
                case animate(toColor: UIColor, options: UIView.AnimationOptions, duration: Double, delay: Double)
            }
            enum RadicalSymbol {
                case add(UIColor)
                case remove
                case reset(UIColor)
            }
        }
    }
    func process(update: Update) {
        switch update {
        case .data(let update):
            switch update {
            case .calculatorFunction(let calculatorFunction):
                self.calculatorFunction = calculatorFunction
            }
        case .label(let update):
            switch update {
            case .attributedText(let text):
                self.views.calculatorFunctionLabelView.label.attributedText = text
            case .centerXConstant(let constant):
                self.views.calculatorFunctionLabelView.centerXConstraint.constant = constant
            case .textColor(let color):
                self.views.calculatorFunctionLabelView.label.textColor = color
            }
        case .view(let update):
            switch update {
            case .background(let update):
                switch update {
                case .backgroundColor(let color):
                    self.backgroundView!.backgroundColor = color
                case .roundCorners:
                    self.layer.cornerRadius = self.frame.height / 2
                    self.layer.masksToBounds = true
                }
            case .highlight(let update):
                switch update {
                case .animate(let toColor, let options, let duration, let delay):
                    UIView.animate(
                        withDuration: duration,
                        delay: delay,
                        options: options,
                        animations: { self.views.highlightView.backgroundColor = toColor },
                        completion: nil)
                }
            case .logicAnimation(let update):
                switch update {
                case .animate(let toColor, let options, let duration, let delay):
                    UIView.animate(
                        withDuration: duration,
                        delay: delay,
                        options: options,
                        animations: { self.views.logicAnimationView.backgroundColor = toColor },
                        completion: nil)
                }
            case .radicalSymbol(let update):
                switch update {
                case .add(let color):
                    self.views.calculatorFunctionLabelView.addRadicalSymbol(color: color)
                case .remove:
                    self.views.calculatorFunctionLabelView.removeRadicalSymbol()
                case .reset(let color):
                    self.views.calculatorFunctionLabelView.resetRadicalSymbol(color: color)
                }
            }
        }
    }
}

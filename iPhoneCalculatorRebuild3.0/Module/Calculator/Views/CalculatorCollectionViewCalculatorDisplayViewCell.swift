//
//  CalculatorCollectionViewCalculatorDisplayViewCell.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

class CalculatorCollectionViewCalculatorDisplayViewCell: UICollectionViewCell {
    
    // MARK: - Models
    
    class DisplayNumber {
        class DisplayNumberLabel: UILabel {
            
            var presenter: CalculatorPresenterToCalculatorViewProtocol!
            var selectorDescriptions: [String] = []
            override var canBecomeFirstResponder: Bool { return true }
            override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
                return self.selectorDescriptions.contains(action.description)
            }
            
            @objc func copyText() {
                self.presenter.respond(to: .calculatorCollectionViewCalculatorDisplayCell(.menuCopyTapped))
            }
            
            @objc func pasteText() {
                self.presenter.respond(to: .calculatorCollectionViewCalculatorDisplayCell(.menuPasteTapped))
            }
        }
        
        let label: DisplayNumberLabel
        let trailingConstraint: NSLayoutConstraint
        let leadingConstraint: NSLayoutConstraint
        
        init(contentView: UIView) {
            self.label = DisplayNumberLabel()
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.label.isUserInteractionEnabled = true
            self.label.textAlignment = .right
            self.label.adjustsFontSizeToFitWidth = true
            self.label.contentScaleFactor = 0.8
            self.trailingConstraint = label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 50)
            self.leadingConstraint = label.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 50)
        }
    }
    class SIUnit {
        let label: UILabel
        let centerXContraint: NSLayoutConstraint
        
        init(contentView: UIView) {
            self.label = UILabel.labelWith(translatesAutoresizingMaskIntoConstraints: false)
            self.centerXContraint = label.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50)
        }
    }
    
    // MARK: - Properties

    static let reuseIdentifier: String = "CalculatorCollectionViewCalculatorDisplayViewCell"
    var displayNumber: DisplayNumber!
    var presenter: CalculatorPresenterToCalculatorViewProtocol! { didSet {
        self.displayNumber.label.presenter = self.presenter
    }}
    var menuController: UIMenuController?
    var siUnit: SIUnit!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.siUnit = SIUnit(contentView: self.contentView)
        self.displayNumber = DisplayNumber(contentView: self.contentView)
        
        contentView.addSubview(self.siUnit.label)
        contentView.addSubview(self.displayNumber.label)
        
        NSLayoutConstraint.activate([
            self.displayNumber.label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.siUnit.label.bottomAnchor.constraint(equalTo: displayNumber.label.lastBaselineAnchor),
            self.siUnit.centerXContraint,
            self.displayNumber.trailingConstraint,
            self.displayNumber.leadingConstraint
        ])
        
        // setup tripletap
        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(self.userTrippleTapped))
        tripleTap.numberOfTapsRequired = 3
        self.addGestureRecognizer(tripleTap)
        
        // setup longpress
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.userLongPressed))
        longPressedGesture.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPressedGesture)
        
        // setup leftswipe
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.userLeftSwiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.addGestureRecognizer(swipeLeft)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Gestures

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.presenter.respond(to: .calculatorCollectionViewCalculatorDisplayCell(.touchesBegan))
    }
    
    @objc func userLeftSwiped(gesture: UIGestureRecognizer) {
        self.presenter.respond(to: .calculatorCollectionViewCalculatorDisplayCell(.userSwipedLeft(gesture: gesture, displayLabel: self.displayNumber.label)))
    }
    
    @objc func userLongPressed() {
        self.presenter.respond(to: .calculatorCollectionViewCalculatorDisplayCell(.userLongPressed))
    }

    @objc func userTrippleTapped() {
        self.presenter.respond(to: .calculatorCollectionViewCalculatorDisplayCell(.userTripleTapped))
    }
    
    @objc func copyText() {
        self.presenter.respond(to: .calculatorCollectionViewCalculatorDisplayCell(.menuCopyTapped))
    }
    
    @objc func pasteText() {
        self.presenter.respond(to: .calculatorCollectionViewCalculatorDisplayCell(.menuPasteTapped))
    }
}

// MARK: - View Update

extension CalculatorCollectionViewCalculatorDisplayViewCell: CalculatorCollectionViewCalculatorDisplayCellPresentationProtocol  {
    enum Update {
        case label(Label)
        case menu(Menu)
        case view(View)
        
        enum Label {
            case displayNumber(DisplayNumber)
            case siUnit(SIUnit)
            
            enum DisplayNumber {
                case attributedText(NSAttributedString)
                case backgroundColor(UIColor)
                case constraintConstant(leading: CGFloat, trailing: CGFloat)
                case textColor(UIColor)
            }
            enum SIUnit {
                case attributedText(NSAttributedString)
                case constraintConstant(centerX: CGFloat)
                case isHidden(Bool)
                case textColor(UIColor)
            }
        }
        enum Menu {
            case add(withPasteOption: Bool)
            case remove
        }
        enum View {
            case backgroundColor(UIColor)
        }
    }
    
    func process(update: Update) {
        switch update {
        case .label(let update):
            switch update {
            case .displayNumber(let update):
                switch update {
                case .attributedText(let text):
                    self.displayNumber.label.attributedText = text
                case .backgroundColor(let color):
                    self.displayNumber.label.backgroundColor = color
                case .textColor(let color):
                    self.displayNumber.label.textColor = color
                case .constraintConstant(let leading, let trailing):
                    self.displayNumber.trailingConstraint.constant = trailing
                    self.displayNumber.leadingConstraint.constant = leading
                    
                }
            case .siUnit(let update):
                switch update {
                case .attributedText(let text):
                    self.siUnit.label.attributedText = text
                case .constraintConstant(let centerX):
                    self.siUnit.centerXContraint.constant = centerX
                case .isHidden(let isHidden):
                    self.siUnit.label.isHidden = isHidden
                case .textColor(let color):
                    self.siUnit.label.textColor = color
                }
            }
        case .menu(let update):
            switch update {
            case .add(let withPasteOption):
                self.displayNumber.label.becomeFirstResponder()
                
                self.menuController = UIMenuController()
                self.menuController?.menuItems = []
                
                let selector: Selector = #selector(self.displayNumber.label.copyText)
                self.displayNumber.label.selectorDescriptions.append(selector.description)
                let menuItem: UIMenuItem = .init(title: "Copy", action: #selector(self.displayNumber.label.copyText))
                self.menuController?.menuItems?.append(menuItem)
                if withPasteOption {
                    let selector: Selector = #selector(self.displayNumber.label.pasteText)
                    self.displayNumber.label.selectorDescriptions.append(selector.description)
                    let menuItem: UIMenuItem = .init(title: "Paste", action: #selector(self.displayNumber.label.pasteText))
                    self.menuController?.menuItems?.append(menuItem)
                }

                self.menuController!.showMenu(from: self, rect: self.displayNumber.label.frame)
            case .remove:
                self.menuController?.hideMenu()
                self.menuController = nil
                self.displayNumber.label.selectorDescriptions = []
            }
        case .view(let update):
            switch update {
            case .backgroundColor(let color):
                self.backgroundColor = color
            }
        }
    }
}

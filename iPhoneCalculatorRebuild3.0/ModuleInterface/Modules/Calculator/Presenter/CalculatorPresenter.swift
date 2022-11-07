//
//  CalculatorPresenter.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

class CalculatorPresenter {

    // MARK: - HandledEvent
    
    enum HandledEvent {
        case interactor(Interactor)
        case moduleInterface(ModuleInterfacePresenter.HandledEvent.Routing.Present.CalculatorModule)
        case view(View)
        
        enum Interactor {
            case active(Calculator)
            case calculatorDisplay(CalculatorDisplay)
            case calculatorKeyboard(CalculatorKeyboard)
            case colorTheme(ColorTheme)
            
            enum CalculatorDisplay {
                case displayNumber(TermProtocol)
                case pastedNumber(TermProtocol)
            }
            enum CalculatorKeyboard {
                case clearFunction(CalculatorFunction)
                case logicAnimation(enabled: Bool)
                case siUnit(CalculatorFunction)
                case show2ndFunctions(Bool)
                case useSelectedAppearance(CalculatorFunction, Bool)
            }
            enum ColorTheme {
                case active(CalculatorColorTheme)
            }
        }
        enum ModuleInterface {
            case willPresentModule
            case willRepresentModule
        }
        enum View {
            case calculatorViewController(CalculatorViewController)
            case calculatorBackground(CalculatorBackground)
            case calculatorCollectionView(CalculatorCollectionView)
            case calculatorCollectionViewCalculatorDisplayCell(CalculatorCollectionViewCalculatorDisplayCell)
            case calculatorCollectionViewFunctionBoardViewCell(CalculatorCollectionViewFunctionBoardViewCell)
            case calculatorFunctionCollectionView(CalculatorFunctionCollectionView)
            case calculatorFunctionCollectionViewCell(CalculatorFunctionCollectionViewCell)
            
            enum CalculatorViewController {
                case loaded(view: CalculatorViewControllerPresentationProtocol)
                case viewWillAppear
                case willLayoutSubviews
            }
            enum CalculatorBackground {
                case loaded(view: CalculatorBackgroundViewPresentationProtocol)
            }
            enum CalculatorCollectionView {
                case loaded(view: CalculatorCollectionViewPresentationProtocol)
            }
            enum CalculatorCollectionViewCalculatorDisplayCell {
                case loaded(view: CalculatorCollectionViewCalculatorDisplayCellPresentationProtocol)
                case touchesBegan
                case userSwipedLeft(gesture: UIGestureRecognizer, displayLabel: UIView)
                case userLongPressed
                case userTripleTapped
                case menuCopyTapped
                case menuPasteTapped
            }
            enum CalculatorCollectionViewFunctionBoardViewCell {
                case loaded(view: CalculatorCollectionViewCalculatorKeyboardViewCellPresentationProtocol)
            }
            enum CalculatorFunctionCollectionView {
                case loaded(view: CalculatorFunctionCollectionViewPresentationProtocol)
                case willLayoutCalculatorFunctionCells
                case didhighlight(cellItemNumber: Int)
                case didUnhighlight(cellItemNumber: Int)
                case didSelect(cellItemNumber: Int)
            }
            enum CalculatorFunctionCollectionViewCell {
                case loaded(view: CalculatorFunctionCollectionViewCellPresentationProtocol, indexPath: IndexPath)
            }
        }
    }
    
    // MARK: - Presentation Model

    private struct PresentationModel {
        struct Data {
            var displayNumber: TermProtocol!
            var copiedNumber: TermProtocol?
            var radicalSymbolFunctions: [CalculatorFunction]!
        }
        struct State {
            var calculator: Calculator!
            var clearFunction: CalculatorFunction! = .allClear
            var logicAnimationEnabled: Bool = false
            var menuAdded: Bool! = false
            var selectedCalculatorFunction: CalculatorFunction?
            var show2ndFunctions: Bool = false
            var siUnit: CalculatorFunction! = .degrees
        }
        struct UI {
            var calculatorContainerSize: CGSize = UIScreen.main.fixedCoordinateSpace.bounds.size
            var colorTheme: CalculatorColorTheme!
            var functionLayout: [Calculator: [CalculatorFunction]] = [
                .scientific: CalculatorFunction.defaultLayout(for: .scientific),
                .standard: CalculatorFunction.defaultLayout(for: .standard)
            ]
        }
        
        var data: Data = Data()
        var state: State = State()
        var ui: UI = UI()
    }
    
    // MARK: - Views
    
    private struct View {
        var calculatorViewController: CalculatorViewControllerPresentationProtocol?
        var calculatorBackground: CalculatorBackgroundViewPresentationProtocol?
        var calculatorCollectionView: CalculatorCollectionViewPresentationProtocol?
        var calculatorCollectionViewDisplayViewCell: CalculatorCollectionViewCalculatorDisplayCellPresentationProtocol?
        var calculatorCollectionViewFunctionBoardViewCell: CalculatorCollectionViewCalculatorKeyboardViewCellPresentationProtocol?
        var calculatorFunctionCollectionView: CalculatorFunctionCollectionViewPresentationProtocol?
        var calculatorFunctionCollectionViewCell: [CalculatorFunction: CalculatorFunctionCollectionViewCellPresentationProtocol?] = [:]
    }
    
    // MARK: - Properties
    
    private var moduleInterface: ModuleInterfacePresenterToModulePresenterProtocol
    private var presentationModel: PresentationModel
    private var views: View
    private var interactor: CalculatorInteractorToCalculatorModulePresenterProtocol!
    
    // MARK: - Init
    
    init(dataManager: DataManager, moduleInterface: ModuleInterfacePresenterToModulePresenterProtocol) {
        self.moduleInterface = moduleInterface
        self.presentationModel = PresentationModel()
        self.views = View()
        self.interactor = CalculatorInteractor(dataManager: dataManager, presenter: self)
    }
    
    // MARK: - View Presentation
    
    enum Present {
        case calculatorViewController(CalculatorViewController)
        case calculatorBackground(CalculatorBackground)
        case calculatorCollectionView(CalculatorCollectionView)
        case calculatorDisplay(CalculatorDisplay)
        case calculatorFunctionCollectionView(CalculatorFunctionCollectionView)
        case calculatorFunctionCollectionViewCell(CalculatorFunctionCollectionViewCell, CalculatorFunction)
        
        enum CalculatorViewController {
            case navBar
            case navTitle
        }
        enum CalculatorBackground {
            case backgroundColor
        }
        enum CalculatorCollectionView {
            case dataSource(DataSource)
            case view(View)
            
            enum DataSource {
                case sectionItemCount
            }
            enum View {
                case layout
            }
        }
        enum CalculatorDisplay {
            case displayNumber(DisplayNumber)
            case menu(Menu)
            case siUnit(SIUnit)
            
            enum DisplayNumber {
                case attributedString
                case textColor
                case trailingConstant
            }
            enum Menu {
                case add
                case remove
            }
            enum SIUnit {
                case attributedString
                case isHidden
                case textColor
                case centerXConstant
            }
        }
        enum CalculatorFunctionCollectionView {
            case dataSource(DataSource)
            case view(View)
            
            enum DataSource {
                case sectionItemCount
            }
            enum View {
                case roundCorners
                case layout
            }
        }
        enum CalculatorFunctionCollectionViewCell {
            case backgroundView(BackgroundView)
            case data(Data)
            case label(CalculatorFunctionLabel)
            case animation(Animation)
            case toggledFunction(newCalculatorFunction: CalculatorFunction)
            
            enum Animation {
                case dimlight
                case highlight
                case undimlight
                case unhighlight
            }
            enum BackgroundView {
                case backgroundColor
            }
            enum CalculatorFunctionLabel {
                case attributedString
                case centerXConstant
                case textColor
                case radical
            }
            enum Data {
                case calculatorFunction
            }
        }
    }
    
    func present(update: Present) {
        switch update {
        case .calculatorBackground(let update):
            guard let view = self.views.calculatorBackground else { return }
            switch update {
            case .backgroundColor:
                view.process(update: .view(.backgroundColor(self.presentationModel.ui.colorTheme.section.calculatorBackground.backgroundColor)))
            }
        case .calculatorCollectionView(let update):
            guard let view = self.views.calculatorCollectionView else { return }
            switch update {
            case .dataSource(let update):
                switch update {
                case .sectionItemCount:
                    view.process(update: .layout(.sectionItemCount([0 : 2])))
                }
            case .view(let update):
                switch update {
                case .layout:
                    guard let viewSize = self.views.calculatorCollectionView?.frame.size else { return }
                    let calculator = self.presentationModel.state.calculator!
                    let containerSize = self.presentationModel.ui.calculatorContainerSize
                    let layout = CalculatorLayout.calculatorCollectionViewCompositionalLayout(calculator: calculator, calculatorCollectionViewSize: viewSize, calculatorContainerSize: containerSize)
                    self.views.calculatorCollectionView?.process(update: .layout(.setLayout(layout: layout)))
                }
            }
        case .calculatorDisplay(let update):
            guard let view = self.views.calculatorCollectionViewDisplayViewCell else { return }
            switch update {
            case .displayNumber(let update):
                switch update {
                case .attributedString:
                    let string = CalculatorDisplayNumberFormatter.string(from: self.presentationModel.data.displayNumber, calculator: self.presentationModel.state.calculator) ?? ""
                    let attributedString = TextFormatter.outputLabel.attributedString(from: string, for: self.presentationModel.state.calculator)
                    view.process(update: .label(.displayNumber(.attributedText(attributedString))))
                case .textColor:
                    let color: UIColor = self.presentationModel.ui.colorTheme.section.calculatorDisplay.textColor
                    view.process(update: .label(.displayNumber(.textColor(color))))
                case .trailingConstant:
                    let calculatorSize: CGSize = self.presentationModel.ui.calculatorContainerSize
                    let viewWidth: CGFloat = calculatorSize.width
                    let keyboardColumns: CGFloat = CGFloat(CalculatorLayout.Section.functionKeyboard.columns(for: self.presentationModel.state.calculator))
                    let calculatorFunctionWidth: CGFloat = viewWidth / keyboardColumns

                    let zero = TextFormatter.outputLabel.attributedString(from: "0", for: self.presentationModel.state.calculator)
                    let constant = (calculatorFunctionWidth - zero.size().width) / 2.0
                    
                    view.process(update: .label(.displayNumber(.constraintConstant(leading: constant, trailing: -constant))))
                }
            case .menu(let update):
                switch update {
                case .add:
                    let withPasteOption: Bool = self.presentationModel.data.copiedNumber != nil
                    view.process(update: .menu(.add(withPasteOption: withPasteOption)))
                case .remove:
                    view.process(update: .menu(.remove))
                }
            case .siUnit(let update):
                switch update {
                case .attributedString:
                    let string = self.presentationModel.state.siUnit.rawValue
                    let attributedString = TextFormatter.siUnitLabel.attributedString(from: string)
                    
                    self.views.calculatorCollectionViewDisplayViewCell?.process(update: .label(.siUnit(.attributedText(attributedString))))
                case .centerXConstant:
                    let calculatorSize: CGSize = self.presentationModel.ui.calculatorContainerSize
                    let viewWidth: CGFloat = calculatorSize.width
                    let keyboardColumns: CGFloat = CGFloat(CalculatorLayout.Section.functionKeyboard.columns(for: self.presentationModel.state.calculator))
                    let calculatorFunctionWidth: CGFloat = viewWidth / keyboardColumns
                    
                    let constant = calculatorFunctionWidth / 2.0
                    
                    self.views.calculatorCollectionViewDisplayViewCell?.process(update: .label(.siUnit(.constraintConstant(centerX: constant))))
                case .isHidden:
                    let isHidden = self.presentationModel.state.calculator == .scientific ? false : true
                    self.views.calculatorCollectionViewDisplayViewCell?.process(update: .label(.siUnit(.isHidden(isHidden))))
                case .textColor:
                    let color: UIColor = self.presentationModel.ui.colorTheme.section.calculatorDisplay.textColor
                    self.views.calculatorCollectionViewDisplayViewCell?.process(update: .label(.siUnit(.textColor(color))))
                }
            }
        case .calculatorFunctionCollectionView(let update):
            guard let view = self.views.calculatorFunctionCollectionView else { return }
            switch update {
            case .dataSource(let update):
                switch update {
                case .sectionItemCount:
                    let sectionItemCount: [Int: Int] = [0: self.presentationModel.state.calculator.functionCount]
                    view.process(update: .layout(.sectionItemCount(sectionItemCount)))
                }
            case .view(let update):
                switch update {
                case .layout:
                    let layout = CalculatorLayout.calculatorFunctionCollectionViewCompositionalLayout(calculator: self.presentationModel.state.calculator, calculatorContainerSize: self.presentationModel.ui.calculatorContainerSize)
                    view.process(update: .layout(.setLayout(layout)))
                case .roundCorners:
                    view.process(update: .view(.roundCorners))
                }
            }
        case .calculatorFunctionCollectionViewCell(let update, let calculatorFunction):
            guard let view = self.views.calculatorFunctionCollectionViewCell[calculatorFunction] else { return }
            
            switch update {
            case .animation(let update):
                switch update {
                case .dimlight:
                    view?.process(update: .view(.logicAnimation(.animate(toColor: .black.withAlphaComponent(0.5), options: .curveEaseIn, duration: 1, delay: 0))))
                case .highlight:
                    view?.process(update: .view(.highlight(.animate(toColor: .white.withAlphaComponent(0.5), options: .curveEaseIn, duration: 1, delay: 0))))
                case .undimlight:
                    view?.process(update: .view(.logicAnimation(.animate(toColor: .clear, options: .curveEaseOut, duration: 1, delay: 0))))
                case .unhighlight:
                    view?.process(update: .view(.highlight(.animate(toColor: .clear, options: .curveEaseOut, duration: 1, delay: 0))))
                }
            case .backgroundView(let update):
                switch update {
                case .backgroundColor:
                    let selected: Bool = self.presentationModel.state.selectedCalculatorFunction == calculatorFunction || calculatorFunction == .secondFunction && self.presentationModel.state.show2ndFunctions
                    let colors = self.presentationModel.ui.colorTheme.section.sectionColors(for: calculatorFunction)
                    guard let backgroundColor = selected ? colors.alternateBackgroundColor : colors.backgroundColor else { fatalError() }
                    
                    view?.process(update: .view(.background(.backgroundColor(backgroundColor))))
                }
            case .data(let update):
                switch update {
                case .calculatorFunction:
                    view?.process(update: .data(.calculatorFunction(calculatorFunction)))
                }
            case .label(let update):
                switch update {
                case .attributedString:
                    let text: NSAttributedString! = {
                        switch self.presentationModel.state.calculator! {
                        case .scientific:
                            return TextFormatter.CalculatorCollectionViewCellLabel.attributedString(for: calculatorFunction, calculator: .scientific)
                        case .standard:
                            return TextFormatter.CalculatorCollectionViewCellLabel.attributedString(for: calculatorFunction, calculator: .standard)
                        }
                    }()
                    view?.process(update: .label(.attributedText(text)))
                case .centerXConstant:
                    let constant: CGFloat = {
                        guard calculatorFunction == .zero else { return 0 }
                        let width: CGFloat = self.presentationModel.ui.calculatorContainerSize.width
                        let columns: CGFloat = CGFloat(CalculatorLayout.Section.functionKeyboard.columns(for: self.presentationModel.state.calculator))
                        let constant: CGFloat = width / columns / 2
                        return -constant
                    }()
                    view?.process(update: .label(.centerXConstant(constant)))
                case .radical:
                    guard CalculatorFunction.FunctionCategory(calculatorFunction: calculatorFunction) == .rootFunction else { view?.process(update: .view(.radicalSymbol(.remove))) ; return }

                    let selected: Bool = self.presentationModel.state.selectedCalculatorFunction == calculatorFunction
                    let colors = self.presentationModel.ui.colorTheme.section.sectionColors(for: calculatorFunction)
                    guard let textColor = selected ? colors.alternateTextColor : colors.textColor else { fatalError() }

                    view?.process(update: .view(.radicalSymbol(.reset(textColor))))
                case .textColor:
                    let selected: Bool = self.presentationModel.state.selectedCalculatorFunction == calculatorFunction || calculatorFunction == .secondFunction && self.presentationModel.state.show2ndFunctions
                    let colors = self.presentationModel.ui.colorTheme.section.sectionColors(for: calculatorFunction)
                    guard let textColor = selected ? colors.alternateTextColor : colors.textColor else { fatalError() }
                    
                    view?.process(update: .label(.textColor(textColor)))
                }
            case .toggledFunction(let nextCalculatorFunction):
                guard let activeView = self.views.calculatorFunctionCollectionViewCell[calculatorFunction] else { return }

                // take active view and update it's presentation to reflect next calculator function
                // copy view
                // nil out its current value
                self.views.calculatorFunctionCollectionViewCell[calculatorFunction] = nil
                // transfer view
                self.views.calculatorFunctionCollectionViewCell[nextCalculatorFunction] = activeView
                
                // Update layout reference array
                if let itemNumber = calculatorFunction.itemNumber(for: .scientific) {
                    self.presentationModel.ui.functionLayout[.scientific]?[itemNumber] = nextCalculatorFunction
                }
                if let itemNumber = calculatorFunction.itemNumber(for: .standard) {
                    self.presentationModel.ui.functionLayout[.standard]?[itemNumber] = nextCalculatorFunction
                }
                
                self.present(update: .calculatorFunctionCollectionViewCell(.backgroundView(.backgroundColor), nextCalculatorFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.data(.calculatorFunction), nextCalculatorFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.attributedString), nextCalculatorFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.textColor), nextCalculatorFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.centerXConstant), nextCalculatorFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.radical), nextCalculatorFunction))
            }
        case .calculatorViewController(let update):
            guard let view = self.views.calculatorViewController else { return }
            switch update {
            case .navBar:
                view.process(update: .navigation(.navigationBar(isHidden: true, shouldAnimate: false)))
            case .navTitle:
                view.process(update: .navigation(.navigationItem(title: "Calculator")))
            }
        }
    }
}

// MARK: - Event Handling: View

extension CalculatorPresenter: CalculatorPresenterToCalculatorViewProtocol {
    func respond(to event: HandledEvent.View) {
        switch event {
        case .calculatorBackground(let event):
            switch event {
            case .loaded(let view):
                self.views.calculatorBackground = view
                self.present(update: .calculatorBackground(.backgroundColor))
            }
        case .calculatorCollectionView(let event):
            switch event {
            case .loaded(let view):
                self.views.calculatorCollectionView = view
                self.present(update: .calculatorCollectionView(.dataSource(.sectionItemCount)))
                self.present(update: .calculatorCollectionView(.view(.layout)))
            }
        case .calculatorCollectionViewCalculatorDisplayCell(let event):
            switch event {
            case .loaded(let view):
                self.views.calculatorCollectionViewDisplayViewCell = view
                self.present(update: .calculatorDisplay(.displayNumber(.attributedString)))
                self.present(update: .calculatorDisplay(.displayNumber(.textColor)))
                self.present(update: .calculatorDisplay(.displayNumber(.trailingConstant)))
                self.present(update: .calculatorDisplay(.siUnit(.attributedString)))
                self.present(update: .calculatorDisplay(.siUnit(.centerXConstant)))
                self.present(update: .calculatorDisplay(.siUnit(.isHidden)))
                self.present(update: .calculatorDisplay(.siUnit(.textColor)))
            case .menuCopyTapped:
                self.interactor.process(update: .persistedData(.copiedNumber))
            case .menuPasteTapped:
                self.presentationModel.data.displayNumber = self.presentationModel.data.copiedNumber
                self.present(update: .calculatorDisplay(.displayNumber(.attributedString)))
                self.present(update: .calculatorDisplay(.displayNumber(.textColor)))
                self.present(update: .calculatorDisplay(.displayNumber(.trailingConstant)))
            case .touchesBegan:
                guard self.presentationModel.state.menuAdded else { return }
                self.present(update: .calculatorDisplay(.menu(.remove)))
            case .userSwipedLeft(let gesture, let displayLabel):
                guard self.presentationModel.data.displayNumber.termType == .mutableNumber else { return }
                let swipeLocation = gesture.location(in: displayLabel)
                let onNumber = swipeLocation.x >= 0 && swipeLocation.y >= 0
                self.interactor.process(update: .persistedData(.userSwipedLeft(onNumber: onNumber)))
            case .userLongPressed:
                guard self.presentationModel.state.menuAdded == false else { return }
                self.present(update: .calculatorDisplay(.menu(.add)))
            case .userTripleTapped:
                break
            }
        case .calculatorCollectionViewFunctionBoardViewCell(let event):
            switch event {
            case .loaded(let view):
                self.views.calculatorCollectionViewFunctionBoardViewCell = view
                self.present(update: .calculatorFunctionCollectionView(.dataSource(.sectionItemCount)))
                self.present(update: .calculatorFunctionCollectionView(.view(.layout)))
            }
        case .calculatorFunctionCollectionView(let event):
            switch event {
            case .didhighlight(cellItemNumber: let cellItemNumber):
                guard let calculatorFunction = self.presentationModel.ui.functionLayout[self.presentationModel.state.calculator]?[cellItemNumber] else { return }
                self.present(update: .calculatorFunctionCollectionViewCell(.animation(.highlight), calculatorFunction))
            case .didUnhighlight(cellItemNumber: let cellItemNumber):
                guard let calculatorFunction = self.presentationModel.ui.functionLayout[self.presentationModel.state.calculator]?[cellItemNumber] else { return }
                self.present(update: .calculatorFunctionCollectionViewCell(.animation(.unhighlight), calculatorFunction))
            case .didSelect(cellItemNumber: let cellItemNumber):
                guard let calculatorFunction = self.presentationModel.ui.functionLayout[self.presentationModel.state.calculator]?[cellItemNumber] else { return }
                self.interactor.process(update: .persistedData(.selectedCalculatorFuncion(calculatorFunction)))
            case .loaded(let view):
                self.views.calculatorFunctionCollectionView = view
                self.present(update: .calculatorFunctionCollectionView(.dataSource(.sectionItemCount)))
                self.present(update: .calculatorFunctionCollectionView(.view(.layout)))
            case .willLayoutCalculatorFunctionCells:
                self.present(update: .calculatorFunctionCollectionView(.view(.roundCorners)))
            }
        case .calculatorFunctionCollectionViewCell(let event):
            switch event {
            case .loaded(let view, let indexPath):
                guard let calculatorFunction = self.presentationModel.ui.functionLayout[self.presentationModel.state.calculator]?[indexPath.item] else { fatalError() }
                self.views.calculatorFunctionCollectionViewCell[calculatorFunction] = view
                
                self.present(update: .calculatorFunctionCollectionViewCell(.backgroundView(.backgroundColor), calculatorFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.data(.calculatorFunction), calculatorFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.attributedString), calculatorFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.centerXConstant), calculatorFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.radical), calculatorFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.textColor), calculatorFunction))
            }
        case .calculatorViewController(let event):
            switch event {
            case .loaded(let view):
                self.views.calculatorViewController = view
                self.present(update: .calculatorViewController(.navTitle))
            case .willLayoutSubviews:
                guard let frame = self.views.calculatorCollectionView?.frame else { return }

                self.interactor.process(update: .calculator(viewSize: frame.size))

                self.presentationModel.ui.calculatorContainerSize = CalculatorLayout.calculatorContainerSize(from: frame.size, calculator: self.presentationModel.state.calculator)
                
                // collectionview
                self.present(update: .calculatorCollectionView(.dataSource(.sectionItemCount)))
                self.present(update: .calculatorCollectionView(.view(.layout)))
                
                // calculator function collectionview
                self.present(update: .calculatorFunctionCollectionView(.dataSource(.sectionItemCount)))
                self.present(update: .calculatorFunctionCollectionView(.view(.layout)))

                let layout = CalculatorLayout.calculatorCollectionViewCompositionalLayout(
                    calculator: self.presentationModel.state.calculator,
                    calculatorCollectionViewSize: frame.size,
                    calculatorContainerSize: self.presentationModel.ui.calculatorContainerSize
                )
                self.views.calculatorCollectionView?.process(update: .layout(.setLayout(layout: layout)))
                
                
                // present changes
                // display
                self.present(update: .calculatorDisplay(.displayNumber(.attributedString)))
                self.present(update: .calculatorDisplay(.displayNumber(.trailingConstant)))
                self.present(update: .calculatorDisplay(.siUnit(.attributedString)))
                self.present(update: .calculatorDisplay(.siUnit(.isHidden)))
                self.present(update: .calculatorDisplay(.siUnit(.centerXConstant)))
                
                // calculator functions
                for calculatorFunction in self.presentationModel.ui.functionLayout[self.presentationModel.state.calculator]! {
                    self.present(update: .calculatorFunctionCollectionViewCell(.label(.attributedString), calculatorFunction))
                }
                // zero constant
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.centerXConstant), .zero))
            case .viewWillAppear:
                self.present(update: .calculatorViewController(.navBar))
            }
        }
    }
}

// MARK: - Event Handling: Interactor

extension CalculatorPresenter: CalculatorPresenterToCalculatorInteractorProtocol {
    func respond(to event: HandledEvent.Interactor) {
        switch event {
        case .active(let calculator):
            self.presentationModel.state.calculator = calculator
        case .calculatorDisplay(let event):
            switch event {
            case .displayNumber(let term):
                self.presentationModel.data.displayNumber = term
                self.present(update: .calculatorDisplay(.displayNumber(.attributedString)))
            case .pastedNumber(let term):
                self.presentationModel.data.displayNumber = term
                self.presentationModel.data.copiedNumber = term
                self.present(update: .calculatorDisplay(.displayNumber(.attributedString)))
            }
        case .calculatorKeyboard(let event):
            switch event {
            case .clearFunction(let calculatorFunction):
                guard self.presentationModel.state.clearFunction != calculatorFunction else { return }
                self.presentationModel.state.clearFunction = calculatorFunction
                self.present(update: .calculatorFunctionCollectionViewCell(.toggledFunction(newCalculatorFunction: calculatorFunction), self.presentationModel.state.clearFunction))
            case .logicAnimation(let enabled):
                self.presentationModel.state.logicAnimationEnabled = enabled
                break
            case .show2ndFunctions(let show2ndFunctions):
                guard self.presentationModel.state.show2ndFunctions != show2ndFunctions else { return }
                let nextCalculatorFunctions = show2ndFunctions ? CalculatorFunction.AdditionalFunctions.second.calculatorFunctions : CalculatorFunction.AdditionalFunctions.first.calculatorFunctions
                
                for nextCalculatorFunction in nextCalculatorFunctions {
                    let itemNumber: Int! = nextCalculatorFunction.itemNumber(for: .scientific)
                    guard let currentFunction: CalculatorFunction = self.presentationModel.ui.functionLayout[.scientific]?[itemNumber] else { return }
                    
                    self.present(update: .calculatorFunctionCollectionViewCell(.toggledFunction(newCalculatorFunction: nextCalculatorFunction), currentFunction))
                }
                self.present(update: .calculatorFunctionCollectionViewCell(.backgroundView(.backgroundColor), .secondFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.attributedString), .secondFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.textColor), .secondFunction))
            case .siUnit(let siUnit):
                self.presentationModel.state.siUnit = siUnit
                
                self.present(update: .calculatorDisplay(.siUnit(.attributedString)))
                self.present(update: .calculatorDisplay(.siUnit(.textColor)))
            case .useSelectedAppearance(let calculatorFunction, let isSelected):
                self.presentationModel.state.selectedCalculatorFunction = isSelected ? calculatorFunction : nil
                self.present(update: .calculatorFunctionCollectionViewCell(.backgroundView(.backgroundColor), calculatorFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.textColor), calculatorFunction))
                self.present(update: .calculatorFunctionCollectionViewCell(.label(.radical), calculatorFunction))
            }
        case .colorTheme(let event):
            switch event {
            case .active(let colorTheme):
                self.presentationModel.ui.colorTheme = colorTheme
                self.present(update: .calculatorBackground(.backgroundColor))
                self.present(update: .calculatorDisplay(.displayNumber(.textColor)))
                self.present(update: .calculatorDisplay(.siUnit(.textColor)))
                
                for calculatorFunction in self.views.calculatorFunctionCollectionViewCell.keys {
                    self.present(update: .calculatorFunctionCollectionViewCell(.backgroundView(.backgroundColor), calculatorFunction))
                    self.present(update: .calculatorFunctionCollectionViewCell(.label(.textColor), calculatorFunction))
                    self.present(update: .calculatorFunctionCollectionViewCell(.label(.radical), calculatorFunction))
                                 
                }
            }
        }
    }
}

// MARK: - Event Handling: Module Interface

extension CalculatorPresenter: CalculatorPresenterToModuleInterfacePresenterProtocol {
    var view: CalculatorViewController {
        return CalculatorViewController(presenter: self)
    }
    
    func respond(to event: ModuleInterfacePresenter.HandledEvent.Routing.Present.CalculatorModule) {
        switch event {
        case .willPresentModule:
            self.interactor.process(update: .persistedData(.load))
        case .willRepresentModule:
            self.interactor.process(update: .persistedData(.reload))
        }
    }
}

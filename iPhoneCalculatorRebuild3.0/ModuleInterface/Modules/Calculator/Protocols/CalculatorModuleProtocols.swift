//
//  CalculatorModuleProtocols.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

// MARK: - CalculatorModulePresenter -> CalculatorView

protocol CalculatorPresenterToCalculatorViewProtocol {
    func respond(to event: CalculatorPresenter.HandledEvent.View)
}

// MARK: - CalculatorModulePresenter -> CalculatorInteractor

protocol CalculatorPresenterToCalculatorInteractorProtocol {
    func respond(to event: CalculatorPresenter.HandledEvent.Interactor)
}

// MARK: - CalculatorModulePresenter -> ModuleInterface

protocol CalculatorPresenterToModuleInterfacePresenterProtocol {
    var view: CalculatorViewController { get }
    func respond(to event: ModuleInterfacePresenter.HandledEvent.Routing.Present.CalculatorModule)
}

// MARK: - CalculatorModulePresenter -> View

protocol CalculatorViewControllerPresentationProtocol {
    func process(update: CalculatorViewController.Update)
}
protocol CalculatorBackgroundViewPresentationProtocol {
    func process(update: CalculatorBackgroundView.Update)
}
protocol CalculatorCollectionViewPresentationProtocol {
    var frame: CGRect { get }
    func process(update: CalculatorCollectionView.Update)
}
protocol CalculatorCollectionViewCalculatorDisplayCellPresentationProtocol {
    func process(update: CalculatorCollectionViewCalculatorDisplayViewCell.Update)
}
protocol CalculatorCollectionViewCalculatorKeyboardViewCellPresentationProtocol {
    func process(update: CalculatorCollectionViewCalculatorFunctionKeyboardViewCell.Update)
}
protocol CalculatorFunctionCollectionViewPresentationProtocol {
    func process(update: CalculatorFunctionCollectionView.Update)
}
protocol CalculatorFunctionCollectionViewCellPresentationProtocol {
    func process(update: CalculatorFunctionCollectionViewCell.Update)
}

// MARK: - CalculatorInteractor -> CalculatorModulePresenter

protocol CalculatorInteractorToCalculatorModulePresenterProtocol {
    func process(update: CalculatorInteractor.Update)
}

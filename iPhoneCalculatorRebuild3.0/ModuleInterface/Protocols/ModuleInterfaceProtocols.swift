//
//  ModuleInterfaceProtocols.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import Foundation

protocol ModuleInterfacePresenterToAppDelegateProtocol {
    func respond(to event: ModuleInterfacePresenter.HandledEvent.AppDelegate)
}

protocol ModuleInterfacePresenterToSceneDelegateProtocol {
    func respond(to event: ModuleInterfacePresenter.HandledEvent.SceneDelegate)
}

protocol ModuleInterfacePresenterToModulePresenterProtocol {
    func respond(to event: ModuleInterfacePresenter.HandledEvent.Routing)
}


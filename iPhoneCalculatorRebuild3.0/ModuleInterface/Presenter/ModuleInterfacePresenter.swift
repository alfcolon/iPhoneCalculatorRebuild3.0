//
//  ModuleInterfacePresenter.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

class ModuleInterfacePresenter {
    
    // MARK: - Handled Event
    
    enum HandledEvent {
        enum AppDelegate {
            case launched(options: [UIApplication.LaunchOptionsKey: Any]?)
        }
        enum SceneDelegate {
            case loaded(window: UIWindow)
        }
        enum Routing {
            case dismiss
            case present(Present)
            
            enum Present {
                case calculator(CalculatorModule)
                case settings(SettingsModule)
                case colorThemes(ColorThemesModule)
                case colorThemeDetails(ColorThemeDetailsModule)
                case colorPicker(ColorPickerModule)
                
                enum CalculatorModule {
                    case willPresentModule
                    case willRepresentModule
                }
                enum SettingsModule {
                    case willPresentModule(logicAnimations: Bool, activeColorTheme: Bool)
                    case willRepresentModule
                }
                enum ColorThemesModule {
                    case willPresentModule
                    case willRespresentModule
                }
                enum ColorThemeDetailsModule {
                    case willPresentModule(colorTheme: CalculatorColorTheme)
                }
                enum ColorPickerModule {
                    case willPresentModule
                }
            }
        }
    }
    
    // MARK: - Modules

    struct ModulePresenter {
        var calculator: CalculatorPresenterToModuleInterfacePresenterProtocol?
        var settings: Void?
        var colorThemes: Void?
        var colorThemeDetails: [UUID: Void]?
        var colorPicker: Void?
    }

    // MARK: - PresentationModel
    
    struct PresentationModel {
        struct State {
            var moduleOrder: [Module] = [.calculator]
            var defaultStartingModule: Module = .calculator
        }
        
        var state: State = State()
    }
    
    // MARK: - Properties
    
    private var dataManager: DataManager!
    private var modules: ModulePresenter!
    private var router: ModuleInterfaceRouter!
    private var interactor: ModuleInterfaceInteractor!
    private var presentationModel: PresentationModel!
}

// MARK: - App Delegate

extension ModuleInterfacePresenter: ModuleInterfacePresenterToAppDelegateProtocol {
    func respond(to event: ModuleInterfacePresenter.HandledEvent.AppDelegate) {
        switch event {
        case .launched(_):
            self.dataManager = DataManager()
            
            self.interactor = ModuleInterfaceInteractor(dataManager: self.dataManager!)
            self.interactor.process(task: .registerTransformers)
            
            self.presentationModel = PresentationModel()
            
            self.modules = ModulePresenter()

            self.router = ModuleInterfaceRouter()
            
            switch self.presentationModel.state.defaultStartingModule {
            case .calculator:
                self.modules.calculator = CalculatorPresenter(dataManager: self.dataManager, moduleInterface: self)
                self.modules.calculator?.respond(to: .willPresentModule)
            default:
                break
            }
        }
    }
}

// MARK: - Scene Delegate

extension ModuleInterfacePresenter: ModuleInterfacePresenterToSceneDelegateProtocol {
    func respond(to event: ModuleInterfacePresenter.HandledEvent.SceneDelegate) {
        switch event {
        case .loaded(let window):
            guard let view = self.modules.calculator?.view else { fatalError() }
            self.router.add(to: window, startingModule: .calculator, view: view)
        }
    }
}

// MARK: - Routing

extension ModuleInterfacePresenter: ModuleInterfacePresenterToModulePresenterProtocol {
    func respond(to event: ModuleInterfacePresenter.HandledEvent.Routing) {
        switch event {
        case .dismiss:
            guard self.presentationModel.state.moduleOrder.count > 1 else { fatalError() }
            self.presentationModel.state.moduleOrder.removeLast()
            
            switch self.presentationModel.state.moduleOrder.last! {
            case .calculator:
                fatalError()
            case .colorPicker:
                self.router.process(task: .pop)
            case .colorThemeDetails:
                self.router.process(task: .pop)
            case  .colorThemes:
                self.router.process(task: .pop)
            case .settings:
                self.router.process(task: .pop)
            }
        case .present(let event):
            switch event {
            case .calculator(let event):
                self.presentationModel.state.moduleOrder.append(.calculator)
                self.modules.calculator?.respond(to: event)
                
                let view = self.modules.calculator?.view ?? {
                    self.modules.calculator = CalculatorPresenter(dataManager: self.dataManager, moduleInterface: self)
                    self.modules.calculator?.respond(to: event)
                    return self.modules.calculator!.view
                }()
                self.router.process(task: .push(view: view))
            default:
                break
            }
        }
    }
}

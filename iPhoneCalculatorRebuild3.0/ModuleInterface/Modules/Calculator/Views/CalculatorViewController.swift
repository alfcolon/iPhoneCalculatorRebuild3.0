//
//  CalculatorViewController.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

class CalculatorViewController: UIViewController {

    // MARK: - Properties
    
    let presenter: CalculatorPresenterToCalculatorViewProtocol
    
    // MARK: - Init

    init(presenter: CalculatorPresenterToCalculatorViewProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.respond(to: .calculatorViewController(.loaded(view: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func loadView() {
        let calculatorBackgroundView = CalculatorBackgroundView(frame: UIScreen.main.fixedCoordinateSpace.bounds, presenter: self.presenter)
        self.view = calculatorBackgroundView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presenter.respond(to: .calculatorViewController(.viewWillAppear))
    }

    override func viewWillLayoutSubviews() {
        self.presenter.respond(to: .calculatorViewController(.willLayoutSubviews))
    }
}

// MARK: - View Updating

extension CalculatorViewController: CalculatorViewControllerPresentationProtocol {
    enum Update {
        case navigation(Navigation)
        
        enum Navigation {
            case navigationBar(isHidden: Bool, shouldAnimate: Bool)
            case navigationItem(title: String)
        }
    }
    
    func process(update: CalculatorViewController.Update) {
        switch update {
        case .navigation(let update):
            switch update {
            case .navigationBar(let isHidden, let shouldAnimate):
                self.navigationController?.setNavigationBarHidden(isHidden, animated: shouldAnimate)
            case .navigationItem(let title):
                self.title = title
            }
        }
    }
}

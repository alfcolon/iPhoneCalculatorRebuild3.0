//
//  CalculatorBackgroundView.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

class CalculatorBackgroundView: UIView {
    
    // MARK: - Properties

    let presenter: CalculatorPresenterToCalculatorViewProtocol
    
    // MARK: - Init
    
    init(frame: CGRect, presenter: CalculatorPresenterToCalculatorViewProtocol) {
        self.presenter = presenter
        
        super.init(frame: frame)
        self.presenter.respond(to: .calculatorBackground(.loaded(view: self)))
        
        let collectionView = CalculatorCollectionView(frame: frame, presenter: self.presenter)
        self.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Updating

extension CalculatorBackgroundView: CalculatorBackgroundViewPresentationProtocol {
    enum Update {
        case view(View)
        
        enum View {
            case backgroundColor(UIColor)
        }
    }
    
    func process(update: CalculatorBackgroundView.Update) {
        switch update {
        case .view(let update):
            switch update {
            case .backgroundColor(let color):
                self.backgroundColor = color
            }
        }
    }
}

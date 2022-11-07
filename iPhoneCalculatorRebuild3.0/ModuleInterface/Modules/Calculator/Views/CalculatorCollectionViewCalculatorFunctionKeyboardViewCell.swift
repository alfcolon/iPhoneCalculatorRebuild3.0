//
//  CalculatorCollectionViewCalculatorFunctionKeyboardViewCell.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

class CalculatorCollectionViewCalculatorFunctionKeyboardViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    var collectionView: CalculatorFunctionCollectionView!
    var presenter: CalculatorPresenterToCalculatorViewProtocol!
    static let reuseIdentifier = "CalculatorCollectionViewCalculatorFunctionKeyboardViewCell"

    // MARK: - Methods
    
    func configure(with presenter: CalculatorPresenterToCalculatorViewProtocol) {
        if self.collectionView == nil {
            self.presenter = presenter
            self.collectionView = CalculatorFunctionCollectionView(frame: frame, presenter: presenter)
            self.contentView.addSubview(self.collectionView)
            NSLayoutConstraint.activate([
                self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
                self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
    }
}

// MARK: - View Update

extension CalculatorCollectionViewCalculatorFunctionKeyboardViewCell: CalculatorCollectionViewCalculatorKeyboardViewCellPresentationProtocol {
    enum Update {
        case data(Data)
        case view(View)
        
        enum Data {
            case presenter(CalculatorPresenterToCalculatorViewProtocol)
        }
        enum View {
            case backgroundColor(UIColor)
        }
    }
    func process(update: CalculatorCollectionViewCalculatorFunctionKeyboardViewCell.Update) {
        switch update {
        case .data(let update):
            switch update {
            case .presenter(let presenter):
                self.presenter = presenter
            }
        case .view(let update):
            switch update {
            case .backgroundColor(let color):
                self.backgroundColor = color
            }
        }
    }
}


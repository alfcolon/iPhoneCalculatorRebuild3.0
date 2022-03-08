//
//  CalculatorCollectionView.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

class CalculatorCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    let presenter: CalculatorPresenterToCalculatorViewProtocol
    var sectionItemCount: [Int: Int] = [0:2]
    
    // MARK: - Init
    
    init(frame: CGRect, presenter: CalculatorPresenterToCalculatorViewProtocol) {
        self.presenter = presenter

        super.init(frame: frame, collectionViewLayout: UICollectionViewCompositionalLayout.singleColumns)
        self.presenter.respond(to: .calculatorCollectionView(.loaded(view: self)))

        self.translatesAutoresizingMaskIntoConstraints = false
        self.isScrollEnabled = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isAccessibilityElement = false
        self.insetsLayoutMarginsFromSafeArea = false
        
        self.delegate = nil
        self.dataSource = self
        
        self.register(CalculatorCollectionViewCalculatorDisplayViewCell.self, forCellWithReuseIdentifier: CalculatorCollectionViewCalculatorDisplayViewCell.reuseIdentifier)
        self.register(CalculatorCollectionViewCalculatorFunctionKeyboardViewCell.self, forCellWithReuseIdentifier: CalculatorCollectionViewCalculatorFunctionKeyboardViewCell.reuseIdentifier)
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionItemCount.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionItemCount[section] ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalculatorCollectionViewCalculatorDisplayViewCell.reuseIdentifier, for: indexPath) as! CalculatorCollectionViewCalculatorDisplayViewCell
            cell.presenter = self.presenter
            self.presenter.respond(to: .calculatorCollectionViewCalculatorDisplayCell(.loaded(view: cell)))
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalculatorCollectionViewCalculatorFunctionKeyboardViewCell.reuseIdentifier, for: indexPath) as! CalculatorCollectionViewCalculatorFunctionKeyboardViewCell
            cell.configure(with: self.presenter)
            self.presenter.respond(to: .calculatorCollectionViewFunctionBoardViewCell(.loaded(view: cell)))
            return cell
        default:
            fatalError()
        }
    }
}

// MARK: - Presentation Protocol Conformance

extension CalculatorCollectionView: CalculatorCollectionViewPresentationProtocol  {
    enum Update {
        case layout(Layout)
        case view(View)
        
        enum Layout {
            case sectionItemCount([Int: Int])
            case setLayout(layout: UICollectionViewCompositionalLayout)
        }
        enum View {
            case backgroundColor(UIColor)
        }
    }
    
    func process(update: Update) {
        switch update {
        case .layout(let layoutUpdate):
            switch layoutUpdate {
            case .sectionItemCount(let sectionItemCount):
                self.sectionItemCount = sectionItemCount
            case .setLayout(let layout):
                self.setCollectionViewLayout(layout, animated: false)
                self.reloadData()
            }
        case .view(let viewUpdate):
            switch viewUpdate {
            case .backgroundColor(let color):
                self.backgroundColor = color
            }
        }
    }
}

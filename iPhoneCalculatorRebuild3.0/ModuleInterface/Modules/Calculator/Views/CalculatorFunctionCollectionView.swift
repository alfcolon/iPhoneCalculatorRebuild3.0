//
//  CalculatorFunctionCollectionView.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit

class CalculatorFunctionCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    let presenter: CalculatorPresenterToCalculatorViewProtocol
    var sectionItemCount: [Int: Int] = [:]
    
    // MARK:  - Init

    init(frame: CGRect, presenter: CalculatorPresenterToCalculatorViewProtocol) {
        self.presenter = presenter

        let startingCompositionalLayout = UICollectionViewCompositionalLayout.singleColumns
        super.init(frame: frame, collectionViewLayout: startingCompositionalLayout)
        self.presenter.respond(to: .calculatorFunctionCollectionView(.loaded(view: self)))
        
        self.dataSource = self
        self.delegate = self
        self.register(CalculatorFunctionCollectionViewCell.self, forCellWithReuseIdentifier: CalculatorFunctionCollectionViewCell.reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isScrollEnabled = false
        self.isAccessibilityElement = false
        self.accessibilityIdentifier = "collection view"
        self.insetsLayoutMarginsFromSafeArea = false
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - View Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        self.presenter.respond(to: .calculatorFunctionCollectionView(.willLayoutCalculatorFunctionCells))
    }

    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionItemCount.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionItemCount[section] ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalculatorFunctionCollectionViewCell.reuseIdentifier, for: indexPath) as! CalculatorFunctionCollectionViewCell
        cell.presenter = presenter
        self.presenter.respond(to: .calculatorFunctionCollectionViewCell(.loaded(view: cell, indexPath: indexPath)))
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.presenter.respond(to: .calculatorFunctionCollectionView(.didhighlight(cellItemNumber: indexPath.item)))
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        self.presenter.respond(to: .calculatorFunctionCollectionView(.didUnhighlight(cellItemNumber: indexPath.item)))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.respond(to: .calculatorFunctionCollectionView(.didSelect(cellItemNumber: indexPath.item)))
    }
}


// MARK: - View Update

extension CalculatorFunctionCollectionView: CalculatorFunctionCollectionViewPresentationProtocol {
    enum Update {
        case layout(Layout)
        case view(View)
        
        enum Layout {
            case sectionItemCount([Int: Int])
            case setLayout(UICollectionViewCompositionalLayout)
        }
        enum View {
            case backgroundColor(UIColor)
            case roundCorners
        }
    }
    
    func process(update: Update) {
        switch update {
        case .layout(let update):
            switch update {
            case .sectionItemCount(let sectionItemCount):
                self.sectionItemCount = sectionItemCount
            case .setLayout(let layout):
                self.setCollectionViewLayout(layout, animated: false) { _ in
                    self.process(update: .view(.roundCorners))
                    self.reloadData()
                }
            }
        case .view(let update):
            switch update {
            case .backgroundColor(let color):
                self.backgroundColor = color
            case .roundCorners:
                let cells = self.visibleCells
                for cell in cells {
                    cell.layer.cornerRadius = cell.frame.height / 2
                    cell.layer.masksToBounds = true
                }
            }
        }
    }
}

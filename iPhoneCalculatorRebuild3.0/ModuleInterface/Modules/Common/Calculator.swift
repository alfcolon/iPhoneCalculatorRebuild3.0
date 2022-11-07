//
//  Calculator.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/16/21.
//

import UIKit

enum Calculator {
    case scientific
    case standard
    
    init(frame: CGRect) {
        self = frame.size.width > frame.size.height ? .scientific : .standard
    }

    enum Section {
        case display
        case functionKeyboard
        
        func compositionalLayout(calculator: Calculator, calculatorSize: CGSize) -> UICollectionViewCompositionalLayout {
            let columns: Int = Calculator.Section.functionKeyboard.columns(for: calculator)
            let rows: Int = Calculator.Section.functionKeyboard.rows(for: calculator)
            let inset: CGFloat = (calculatorSize.width / CGFloat(columns)) * 0.05
            let itemInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            let compositionalLayout: UICollectionViewCompositionalLayout = {
                let item: NSCollectionLayoutItem = {
                    let size: NSCollectionLayoutSize = {
                        let width: NSCollectionLayoutDimension = .fractionalWidth(1 / CGFloat(columns))
                        let height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
                        return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
                    }()
                    let item = NSCollectionLayoutItem(layoutSize: size)
                    item.contentInsets = itemInsets
                    return item
                }()
                let zeroItem: NSCollectionLayoutItem = {
                    let size: NSCollectionLayoutSize = {
                        let width: NSCollectionLayoutDimension = .fractionalWidth(1 / CGFloat(columns) *  2)
                        let height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
                        return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
                    }()
                    let item = NSCollectionLayoutItem(layoutSize: size)
                    item.contentInsets = itemInsets
                    return item
                }()
                
                let row: NSCollectionLayoutGroup = {
                    let size: NSCollectionLayoutSize = {
                        let width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
                        let height: NSCollectionLayoutDimension = .fractionalHeight(0.2)
                        return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
                    }()
                    let subitems: [NSCollectionLayoutItem] = (0..<columns).map { _ in return item }
                    return NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: subitems)
                }()
                let zeroRow: NSCollectionLayoutGroup = {
                    let size: NSCollectionLayoutSize = {
                        let width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
                        let height: NSCollectionLayoutDimension = .fractionalHeight(0.2)
                        return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
                    }()
                    let subitems: [NSCollectionLayoutItem] = (0..<columns).map {
                        let zero = columns - 4
                        return $0 == zero ? zeroItem : item
                    }
                    return NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: subitems)
                }()
                let group: NSCollectionLayoutGroup = {
                    let size: NSCollectionLayoutSize = {
                        let width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
                        let height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
                        
                        return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
                    }()
                    let subitems: [NSCollectionLayoutItem] = (0..<rows).map{
                        let zero = rows - 1
                        return $0 == zero ? zeroRow : row
                    }
                    return NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: subitems)
                }()
                let section = NSCollectionLayoutSection(group: group)
                return UICollectionViewCompositionalLayout(section: section)
            }()
            return compositionalLayout
        }
        func rowHeightToRowWidthRatio(for calculator: Calculator) -> CGFloat {
            switch self {
            case .display:
                switch calculator {
                case .scientific:
                    return 0.8
                case .standard:
                    return 0.8
                }
            case .functionKeyboard:
                switch calculator {
                case .scientific:
                    return 0.8
                case .standard:
                    return 3
                }
            }
        }
        func columns(for calculator: Calculator) -> Int {
            switch self {
            case .display:
                switch calculator {
                case .scientific:
                    return 1
                case .standard:
                    return 1
                }
            case .functionKeyboard:
                switch calculator {
                case .scientific:
                    return 10
                case .standard:
                    return 4
                }
            }
        }
        
        func rows(for calculator: Calculator) -> Int {
            switch self {
            case .display:
                switch calculator {
                case .scientific:
                    return 1
                case .standard:
                    return 1
                }
            case .functionKeyboard:
                switch calculator {
                case .scientific:
                    return 5
                case .standard:
                    return 5
                }
            }
        }
        
        func sectionHeightRatio(for calculator: Calculator) -> CGFloat {
            switch self {
            case .display:
                switch calculator {
                case .scientific:
                    return 1/6
                case .standard:
                    return 3/8
                }
            case .functionKeyboard:
                switch calculator {
                case .scientific:
                    return 5/6
                case .standard:
                    return 5/8
                }
            }
        }
    }
    
    var functionCount: Int {
        switch self {
        case .scientific:
            return 49
        case .standard:
            return 19
        }
    }

    var mutableNumberDigitMaximum: Int {
        switch self {
        case .scientific:
            return 16
        case .standard:
            return 9
        }
    }

    func size(from viewSize: CGSize) -> CGSize {
        let testSize: CGSize = {
            switch self {
            case .scientific:
                return CGSize(width: 100, height: 48)
            case .standard:
                return CGSize(width: 40, height: 80)
            }
        }()
        
        var containerSize = testSize
        containerSize.width *= viewSize.height
        containerSize.height *= viewSize.height

        var adjustment: CGFloat = viewSize.height / containerSize.height
        containerSize.width *= adjustment
        containerSize.height *= adjustment

        if viewSize.width < containerSize.width {
            adjustment = viewSize.width / containerSize.width
            containerSize.width *= adjustment
            containerSize.height *= adjustment
        }
        
        if containerSize.width > viewSize.width {
            adjustment = viewSize.width / containerSize.width
            containerSize.width *= adjustment
            containerSize.height *= adjustment
        }
        
        let heightRatio: CGFloat = testSize.height / testSize.width
        let targetHeight: CGFloat = containerSize.width * heightRatio
        containerSize.height = targetHeight

//        return CGSize(width: 80, height: 160)
        return containerSize

    }
    
    func compositionalLayout(frame: CGRect, calculatorSize: CGSize) -> UICollectionViewCompositionalLayout {
        let viewSize = frame.size
        
        let item1HeightRatio: CGFloat = Calculator.Section.display.sectionHeightRatio(for: self)
        let item1LayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(item1HeightRatio))
        let item1 = NSCollectionLayoutItem(layoutSize: item1LayoutSize)
        
        let item2HeightRatio: CGFloat = Calculator.Section.functionKeyboard.sectionHeightRatio(for: self)
        let item2LayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(item2HeightRatio))
        let item2 = NSCollectionLayoutItem(layoutSize: item2LayoutSize)
        
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize, subitems: [item1, item2])
        
        let insets: NSDirectionalEdgeInsets = {
            let heightDifference: CGFloat = viewSize.height - calculatorSize.height
            let widthDifference: CGFloat = viewSize.width - calculatorSize.width

            let top: CGFloat = self == .standard ? 0 : heightDifference / 2
            // since this is pushing up, it can only go so far as the layout margins to avoid overlap, so the layout margin has to be passed in to avoid overlap
            let bottom: CGFloat = self == .standard ? heightDifference : heightDifference / 2
            let leading: CGFloat = widthDifference / 2
            let trailing: CGFloat = widthDifference / 2
            return NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        }()
        group.contentInsets = insets
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func compositionalLayoutUpdate(viewSize: CGSize, calculatorSize: CGSize) -> UICollectionViewCompositionalLayout {
        let item1HeightRatio: CGFloat = Calculator.Section.display.sectionHeightRatio(for: self)
        let item1LayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(item1HeightRatio))
        let item1 = NSCollectionLayoutItem(layoutSize: item1LayoutSize)
        
        let item2HeightRatio: CGFloat = Calculator.Section.functionKeyboard.sectionHeightRatio(for: self)
        let item2LayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(item2HeightRatio))
        let item2 = NSCollectionLayoutItem(layoutSize: item2LayoutSize)
        
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize, subitems: [item1, item2])
        
        let insets: NSDirectionalEdgeInsets = {
            let heightDifference: CGFloat = viewSize.height - calculatorSize.height
            let widthDifference: CGFloat = viewSize.width - calculatorSize.width

            let top: CGFloat = self == .standard ? 0 : heightDifference / 2
            // since this is pushing up, it can only go so far as the layout margins to avoid overlap, so the layout margin has to be passed in to avoid overlap
            let bottom: CGFloat = self == .standard ? heightDifference : heightDifference / 2
            let leading: CGFloat = widthDifference / 2
            let trailing: CGFloat = widthDifference / 2
            return NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        }()
        group.contentInsets = insets
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    /*
        Backwards
        
            keyboardRows = 5
            keyboardRowHeightToWidthRatio = 0.8
            keyboardHeightToWidthRatio = keyboardRowHeightToWidthRatio * keyboardRows
            
            displayRows = 1
            // relative to row
            keyboardRowHeightToWidthRatio = keyboardRowHeightToWidthRatio * displayRows
            // relative to height, make it shrink horizontally
            keyboardHeightToWidthRatio = keyboardHeightToWidthRatio * 0.5
            // relative...
            ...
    
            displayRows = 1
            keyboardRows = 5
    
    */
    
}

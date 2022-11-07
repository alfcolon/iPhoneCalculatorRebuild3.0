//
//  CalculatorLayout.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/2/22.
//

import UIKit
//
//struct CalculatorLayout {
//    enum Section {
//        case display
//        case functionKeyboard
//
//        func rowHeightToRowWidthRatio(for calculator: Calculator) -> CGFloat {
//            switch self {
//            case .display:
//                switch calculator {
//                case .scientific:
//                    return 0.8
//                case .standard:
//                    return 0.8
//                }
//            case .functionKeyboard:
//                switch calculator {
//                case .scientific:
//                    return 0.8
//                case .standard:
//                    return 3
//                }
//            }
//        }
//        func columns(for calculator: Calculator) -> Int {
//            switch self {
//            case .display:
//                switch calculator {
//                case .scientific:
//                    return 1
//                case .standard:
//                    return 1
//                }
//            case .functionKeyboard:
//                switch calculator {
//                case .scientific:
//                    return 10
//                case .standard:
//                    return 4
//                }
//            }
//        }
//
//        func rows(for calculator: Calculator) -> Int {
//            switch self {
//            case .display:
//                switch calculator {
//                case .scientific:
//                    return 1
//                case .standard:
//                    return 1
//                }
//            case .functionKeyboard:
//                switch calculator {
//                case .scientific:
//                    return 5
//                case .standard:
//                    return 5
//                }
//            }
//        }
//
//        func sectionHeightRatio(for calculator: Calculator) -> CGFloat {
//            switch self {
//            case .display:
//                switch calculator {
//                case .scientific:
//                    return 1/6
//                case .standard:
//                    return 3/8
//                }
//            case .functionKeyboard:
//                switch calculator {
//                case .scientific:
//                    return 5/6
//                case .standard:
//                    return 5/8
//                }
//            }
//        }
//    }
//
//    static func calculatorContainerSize(from calculatorCollectionViewSize: CGSize, calculator: Calculator) -> CGSize {
//        let testSize: CGSize = {
//            switch calculator {
//            case .scientific:
//                return CGSize(width: 100, height: 48)
//            case .standard:
//                return CGSize(width: 40, height: 80)
//            }
//        }()
//
//        var containerSize = testSize
//        containerSize.width *= calculatorCollectionViewSize.width
//        containerSize.height *= calculatorCollectionViewSize.width
//
//        // make container larger than current view size
//        var adjustment: CGFloat = calculatorCollectionViewSize.height / containerSize.height
//        containerSize.width *= adjustment
//        containerSize.height *= adjustment
//
//        //  find width adjustment using viewWidth / containerWidth and update container width and height
//        if calculatorCollectionViewSize.width < containerSize.width {
//            adjustment = calculatorCollectionViewSize.width / containerSize.width
//            containerSize.width *= adjustment
//            containerSize.height *= adjustment
//        }
//
//        // now, if the containerHeight is > the viewheight, adjust
//        // find height adjustment using viewHeight / containerHeight and update container width and height
//        if containerSize.height > calculatorCollectionViewSize.height {
//            adjustment = calculatorCollectionViewSize.height / containerSize.height
//            containerSize.width *= adjustment
//            containerSize.height *= adjustment
//        }
//
//        return containerSize
//
//    }
//    static func calculatorCollectionViewCompositionalLayout(calculator: Calculator, calculatorCollectionViewSize viewSize: CGSize, calculatorContainerSize: CGSize) -> UICollectionViewCompositionalLayout {
//        let item1HeightRatio: CGFloat = CalculatorLayout.Section.display.sectionHeightRatio(for: calculator)
//        let item1LayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(item1HeightRatio))
//        let item1 = NSCollectionLayoutItem(layoutSize: item1LayoutSize)
//
//        let item2HeightRatio: CGFloat = CalculatorLayout.Section.functionKeyboard.sectionHeightRatio(for: calculator)
//        let item2LayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(item2HeightRatio))
//        let item2 = NSCollectionLayoutItem(layoutSize: item2LayoutSize)
//
//        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize, subitems: [item1, item2])
//
//        let insets: NSDirectionalEdgeInsets = {
//            let heightDifference: CGFloat = viewSize.height - calculatorContainerSize.height
//            let widthDifference: CGFloat = viewSize.width - calculatorContainerSize.width
//
//            let top: CGFloat = calculator == .standard ? 0 : heightDifference / 2
//            // since this is pushing up, it can only go so far as the layout margins to avoid overlap, so the layout margin has to be passed in to avoid overlap
//            let bottom: CGFloat = calculator == .standard ? heightDifference : heightDifference / 2
//            let leading: CGFloat = widthDifference / 2
//            let trailing: CGFloat = widthDifference / 2
//            return NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
//        }()
//        group.contentInsets = insets
//
//        let section = NSCollectionLayoutSection(group: group)
//
//        return UICollectionViewCompositionalLayout(section: section)
//    }
//
//    static func calculatorFunctionCollectionViewCompositionalLayout(calculator: Calculator, calculatorContainerSize: CGSize) -> UICollectionViewCompositionalLayout {
//        let columns: Int = CalculatorLayout.Section.functionKeyboard.columns(for: calculator)
//        let rows: Int = CalculatorLayout.Section.functionKeyboard.rows(for: calculator)
//        let inset: CGFloat = (calculatorContainerSize.width / CGFloat(columns)) * 0.05
//        let itemInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
//        let compositionalLayout: UICollectionViewCompositionalLayout = {
//            let item: NSCollectionLayoutItem = {
//                let size: NSCollectionLayoutSize = {
//                    let width: NSCollectionLayoutDimension = .fractionalWidth(1 / CGFloat(columns))
//                    let height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
//                    return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
//                }()
//                let item = NSCollectionLayoutItem(layoutSize: size)
//                item.contentInsets = itemInsets
//                return item
//            }()
//            let zeroItem: NSCollectionLayoutItem = {
//                let size: NSCollectionLayoutSize = {
//                    let width: NSCollectionLayoutDimension = .fractionalWidth(1 / CGFloat(columns) *  2)
//                    let height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
//                    return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
//                }()
//                let item = NSCollectionLayoutItem(layoutSize: size)
//                item.contentInsets = itemInsets
//                return item
//            }()
//
//            let row: NSCollectionLayoutGroup = {
//                let size: NSCollectionLayoutSize = {
//                    let width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
//                    let height: NSCollectionLayoutDimension = .fractionalHeight(0.2)
//                    return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
//                }()
//                let subitems: [NSCollectionLayoutItem] = (0..<columns).map { _ in return item }
//                return NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: subitems)
//            }()
//            let zeroRow: NSCollectionLayoutGroup = {
//                let size: NSCollectionLayoutSize = {
//                    let width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
//                    let height: NSCollectionLayoutDimension = .fractionalHeight(0.2)
//                    return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
//                }()
//                let subitems: [NSCollectionLayoutItem] = (0..<columns).map {
//                    let zero = columns - 4
//                    return $0 == zero ? zeroItem : item
//                }
//                return NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: subitems)
//            }()
//            let group: NSCollectionLayoutGroup = {
//                let size: NSCollectionLayoutSize = {
//                    let width: NSCollectionLayoutDimension = .fractionalWidth(1.0)
//                    let height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
//
//                    return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
//                }()
//                let subitems: [NSCollectionLayoutItem] = (0..<rows).map{
//                    let zero = rows - 1
//                    return $0 == zero ? zeroRow : row
//                }
//                return NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: subitems)
//            }()
//            let section = NSCollectionLayoutSection(group: group)
//            return UICollectionViewCompositionalLayout(section: section)
//        }()
//        return compositionalLayout
//    }
//}
//

struct CalculatorLayout {
    enum Section {
        case display
        case functionKeyboard
        
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
    
    static func calculatorContainerSize(from calculatorCollectionViewSize: CGSize, calculator: Calculator) -> CGSize {
        let testSize: CGSize = {
            switch calculator {
            case .scientific:
                return CGSize(width: 100, height: 48)
            case .standard:
                return CGSize(width: 40, height: 80)
            }
        }()
        
        var containerSize = testSize
        containerSize.width *= calculatorCollectionViewSize.height
        containerSize.height *= calculatorCollectionViewSize.height

        var adjustment: CGFloat = calculatorCollectionViewSize.height / containerSize.height
        containerSize.width *= adjustment
        containerSize.height *= adjustment

        if calculatorCollectionViewSize.width < containerSize.width {
            adjustment = calculatorCollectionViewSize.width / containerSize.width
            containerSize.width *= adjustment
            containerSize.height *= adjustment
        }
        
        if containerSize.width > calculatorCollectionViewSize.width {
            adjustment = calculatorCollectionViewSize.width / containerSize.width
            containerSize.width *= adjustment
            containerSize.height *= adjustment
        }
        
        let heightRatio: CGFloat = testSize.height / testSize.width
        let targetHeight: CGFloat = containerSize.width * heightRatio
        containerSize.height = targetHeight

        return containerSize

    }
    static func calculatorCollectionViewCompositionalLayout(calculator: Calculator, calculatorCollectionViewSize viewSize: CGSize, calculatorContainerSize: CGSize) -> UICollectionViewCompositionalLayout {
        let item1HeightRatio: CGFloat = CalculatorLayout.Section.display.sectionHeightRatio(for: calculator)
        let item1LayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(item1HeightRatio))
        let item1 = NSCollectionLayoutItem(layoutSize: item1LayoutSize)
        
        let item2HeightRatio: CGFloat = CalculatorLayout.Section.functionKeyboard.sectionHeightRatio(for: calculator)
        let item2LayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(item2HeightRatio))
        let item2 = NSCollectionLayoutItem(layoutSize: item2LayoutSize)
        
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize, subitems: [item1, item2])
        
        let insets: NSDirectionalEdgeInsets = {
            let heightDifference: CGFloat = viewSize.height - calculatorContainerSize.height
            let widthDifference: CGFloat = viewSize.width - calculatorContainerSize.width

            let top: CGFloat = calculator == .standard ? 0 : heightDifference / 2
            // since this is pushing up, it can only go so far as the layout margins to avoid overlap, so the layout margin has to be passed in to avoid overlap
            let bottom: CGFloat = calculator == .standard ? heightDifference : heightDifference / 2
            let leading: CGFloat = widthDifference / 2
            let trailing: CGFloat = widthDifference / 2
            return NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        }()
        group.contentInsets = insets
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    static func calculatorFunctionCollectionViewCompositionalLayout(calculator: Calculator, calculatorContainerSize: CGSize) -> UICollectionViewCompositionalLayout {
        let columns: Int = CalculatorLayout.Section.functionKeyboard.columns(for: calculator)
        let rows: Int = CalculatorLayout.Section.functionKeyboard.rows(for: calculator)
        let inset: CGFloat = (calculatorContainerSize.width / CGFloat(columns)) * 0.05
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
}

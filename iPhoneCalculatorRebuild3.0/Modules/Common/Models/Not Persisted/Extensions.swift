//
//  Extensions.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 12/19/21.
//

import Foundation

import UIKit

extension UIColor {
	static let darkLiverish = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
	static let eerieBlackish = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
	static let lightGrayish = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1.00)
	static let vividGambogeish = UIColor(red: 1.00, green: 0.62, blue: 0.04, alpha: 1.00)
}

extension Bool {
	var number: NSNumber {
		return NSNumber(booleanLiteral: self)
	}
	var signNegationDoubleValue: Double  {
		return self == true ? -1 : 1
	}
}

extension Double {
	var number: NSNumber {
		return NSNumber(value: self)
	}
}

extension Int {
	var cgFloat: CGFloat {
		return CGFloat(self)
	}
}

extension NSString {
	var string: String {
		return String(self)
	}
	var stringArray: [String] {
		return self.string.map { return String($0) }
	}
}

extension String {
	var nsString: NSString { return NSString(string: self) }
}

extension CGSize {
	var swap: CGSize {
		return CGSize(width: self.height, height: self.width)
	}
}

extension UIButton {
	static func star(isSelected: Bool) -> UIButton {
		let button = UIButton()
		button.setImage(UIImage(systemName: "star"), for: .normal)
		button.setImage(UIImage(systemName: "star.fill"), for: .selected)
		button.tintColor = .blue
		
		let action = UIAction { _ in
			button.isSelected.toggle()
		}
		button.addAction(action, for: .allEvents)
		
		return button
	}
}

extension Date {
	static var zeroTimeSince1970: Date { return Date(timeIntervalSince1970: 0) }
}

extension UICollectionViewCompositionalLayout {
	static var singleColumns: UICollectionViewCompositionalLayout {
		let item: NSCollectionLayoutItem = {
			let size: NSCollectionLayoutSize = {
				let width = NSCollectionLayoutDimension.fractionalWidth(1.0)
				let height = NSCollectionLayoutDimension.fractionalWidth(1.0)
				return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
			}()
			let item = NSCollectionLayoutItem(layoutSize: size)
			return item
		}()
		let group: NSCollectionLayoutGroup = {
			let size: NSCollectionLayoutSize = {
				let width = NSCollectionLayoutDimension.fractionalWidth(1.0)
				let height = NSCollectionLayoutDimension.fractionalWidth(1.0)
				return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
			}()
			let subitems: [NSCollectionLayoutItem] = [item]
			return NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: subitems)
		}()
		let section = NSCollectionLayoutSection(group: group)
		return UICollectionViewCompositionalLayout(section: section)
	}
}

extension UILabel {
	static func labelWith(frame: CGRect, translatesAutoresizingMaskIntoConstraints bool: Bool) -> UILabel {
		let label = UILabel(frame: frame)
		label.translatesAutoresizingMaskIntoConstraints = bool
		return label
	}
	static func labelWith(translatesAutoresizingMaskIntoConstraints bool: Bool) -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
}

extension UIView {
	
	convenience init(frame: CGRect, translatesAutoresizingMaskIntoConstraints bool: Bool) {
		self.init(frame: frame)
		self.translatesAutoresizingMaskIntoConstraints = bool
	}
	
	convenience init(translatesAutoresizingMaskIntoConstraints bool: Bool) {
		self.init()
		self.translatesAutoresizingMaskIntoConstraints = bool
	}
	
	func addAndConstrain(subview: UIView) {
		self.addSubview(subview)
		NSLayoutConstraint.activate([
			subview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			subview.topAnchor.constraint(equalTo: self.topAnchor),
			subview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			subview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
		])
	}
	
	func addAndConstrainToSafeArea(subview: UIView) {
		self.addSubview(subview)
		NSLayoutConstraint.activate([
			subview.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
			subview.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			subview.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
			subview.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
		])
	}
	
	func addLabelAndConstrainToCenter(subview: UIView) {
		self.addSubview(subview)
		NSLayoutConstraint.activate([
			subview.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
			subview.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			subview.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
			subview.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
		])
	}
}

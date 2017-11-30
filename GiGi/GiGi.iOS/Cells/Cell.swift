//
//  Cell.swift
//  GiGi
//
//  Created by Sean Cheng on 29/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import Cartography

class Cell: UICollectionViewCell
{
	enum AccessoryType
	{
		case `default`
		case add
		case uncheck
		case checked
		case description(string: String)
	}
	
	let titleLabel: UILabel = UILabel()
	let seperator = UIView()
	
	var icon: UIImage? { didSet { setIcon() } }
	var accessoryType: AccessoryType? { didSet { setAccessoryType() } }
	var leftView: UIView? { didSet { setLeftView() } }
	var rightView: UIView? { didSet { setRightView() } }
	
	private var _titleLeadingConstraint: NSLayoutConstraint!
	private var _seperatorLeadingConstraint: NSLayoutConstraint!
	
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		
		titleLabel.numberOfLines = 0
		titleLabel.font = Font.CellFont
		contentView.addSubview(titleLabel)

		self.backgroundView = UIView()

		contentView.addSubview(seperator)
		
		let heightLayout = NSLayoutConstraint.init(item: self.contentView, attribute: NSLayoutAttribute.height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 0, constant: Constants.cellHeight)
		contentView.addConstraint(heightLayout)
		
		constrain(titleLabel, seperator)
		{
			titleLabel, seperator in
			
			titleLabel.trailing == titleLabel.superview!.trailing - Constants.cellHeight
			titleLabel.top == titleLabel.superview!.top + 12
			titleLabel.bottom == titleLabel.superview!.bottom - 12
			_titleLeadingConstraint = titleLabel.leading == titleLabel.superview!.leading + 15
			
			seperator.height == 0.5
			seperator.bottom == seperator.superview!.bottom
			seperator.trailing == seperator.superview!.trailing
			_seperatorLeadingConstraint = seperator.leading == seperator.superview!.leading + 15
		}
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	override func tintColorDidChange()
	{
		super.tintColorDidChange()

		if let leftView = leftView { leftView.tintColor = Theme.colors[4] }
		if let rightView = rightView { rightView.tintColor = Theme.colors[3] }
		backgroundView?.backgroundColor = Theme.colors[0]
		seperator.backgroundColor = Theme.colors[1]
		titleLabel.textColor = tintColor
	}
	
	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes
	{
		var newFrame = layoutAttributes.frame
		newFrame.size = contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
		layoutAttributes.frame = newFrame
		return layoutAttributes
	}

	override func prepareForReuse()
	{
		super.prepareForReuse()
		leftView?.removeFromSuperview()
		rightView?.removeFromSuperview()
		titleLabel.text = nil
		isHighlighted = false
	}

	func isHighlighted(highlight: Bool, animateDuration: TimeInterval = 0)
	{
		UIView.animate(withDuration: animateDuration)
		{
			if highlight { self.titleLabel.textColor = Theme.colors[8] }
			else { self.titleLabel.textColor = Theme.colors[6] }
		}
	}
}

extension Cell
{
	func redrawSeperator()
	{
		var leftMargin : CGFloat = 15
		if leftView != nil { leftMargin = 55 }
		_seperatorLeadingConstraint.constant = leftMargin
		_titleLeadingConstraint.constant = leftMargin
	}
	
	func setIcon()
	{
		guard let image = icon else { leftView = UIView(); return }
		leftView = UIImageView(image: image)
	}
	
	func setAccessoryType()
	{
		rightView?.removeFromSuperview()
		guard let type = accessoryType else { rightView = nil; return }
		switch type
		{
		case .add: rightView = UIImageView(image: #imageLiteral(resourceName: "Accessory-Add"))
		case .default: rightView = UIImageView(image: #imageLiteral(resourceName: "Accessory-Default"))
		case .uncheck: rightView = UIImageView(image: #imageLiteral(resourceName: "Accessory-Deselected"))
		case .checked: rightView = UIImageView(image: #imageLiteral(resourceName: "Accessory-Selected"))
		case .description(let string):
			let label = UILabel()
			label.font = Font.CellDescriptionFont
			label.textColor = Theme.colors[3]
			label.text = string
			rightView = label
		}
	}

	func setLeftView()
	{
		redrawSeperator()
		if let constraints = leftView?.constraints { leftView?.removeConstraints(constraints) }
		if leftView?.superview == nil
		{
			contentView.addSubview(leftView!)
			leftView?.contentMode = .center
			
			constrain(leftView!)
			{
				leftView in
				leftView.leading == leftView.superview!.leading
				leftView.width == Constants.cellHeight - 1
				leftView.height == Constants.cellHeight - 1
				leftView.top == leftView.superview!.top
			}
		}
		leftView?.tintColor = Theme.colors[4]
	}
	
	func setRightView()
	{
		if let constraints = rightView?.constraints { rightView?.removeConstraints(constraints) }
		if rightView?.superview == nil
		{
			rightView?.contentMode = .center
			contentView.addSubview(rightView!)

			constrain(rightView!)
			{
				view in
				view.trailing == view.superview!.trailing - Constants.edgeMargin
				if rightView is UISwitch == false { view.height == Constants.cellHeight - 1 }
				view.centerY == view.superview!.centerY
			}
		}
		rightView?.tintColor = Theme.colors[3]
	}
}

//
//  Cell.swift
//  GiGi
//
//  Created by Sean Cheng on 29/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class Cell: UICollectionViewCell
{
	enum AccessoryType
	{
		case `default`
		case add
	}
	
	weak var delegate: ItemCellDelegate?
	
	var titleLabel: UILabel = UILabel()
	var icon: UIImage? { didSet { setIcon() } }
	var accessoryType: AccessoryType? { didSet { setAccessoryType() } }
	var leftView: UIView? { didSet { setLeftView() } }
	var rightView: UIView? { didSet { setRightView() } }
	
	private var _seperator: CALayer?
	private var _titleLeadingConstraint: NSLayoutConstraint!
	private var _seperatorLeadingConstraint: NSLayoutConstraint!
	
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		
		contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.cellHeight).isActive = true
		titleLabel.numberOfLines = 0
		titleLabel.font = Theme.CellFont
		contentView.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cellHeight).isActive = true
		titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
		_titleLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
		_titleLeadingConstraint.isActive = true
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = Theme.colors[0]
		self.backgroundView = backgroundView
		
		let seperator = UIView()
		seperator.backgroundColor = Theme.colors[1]
		contentView.addSubview(seperator)
		seperator.translatesAutoresizingMaskIntoConstraints = false
		seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
		seperator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		seperator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		_seperatorLeadingConstraint = seperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
		_seperatorLeadingConstraint.isActive = true
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
//		backgroundColor = Theme.colors[0]
		titleLabel.textColor = tintColor
	}
	
	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes
	{
		let size = contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
		var newFrame = layoutAttributes.frame
		newFrame.size.height = size.height
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
			leftView?.translatesAutoresizingMaskIntoConstraints = false
			leftView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
			leftView?.widthAnchor.constraint(equalToConstant: Constants.cellHeight - 1).isActive = true
			leftView?.heightAnchor.constraint(equalToConstant: Constants.cellHeight - 1).isActive = true
			leftView?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		}
		leftView?.tintColor = Theme.colors[4]
	}
	
	func setRightView()
	{
		if let constraints = rightView?.constraints { rightView?.removeConstraints(constraints) }
		if rightView?.superview == nil
		{
			contentView.addSubview(rightView!)
			rightView?.contentMode = .center
			rightView?.translatesAutoresizingMaskIntoConstraints = false
			rightView?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
			rightView?.widthAnchor.constraint(equalToConstant: Constants.cellHeight - 1).isActive = true
			rightView?.heightAnchor.constraint(equalToConstant: Constants.cellHeight - 1).isActive = true
			rightView?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		}
		rightView?.tintColor = Theme.colors[3]
	}
}

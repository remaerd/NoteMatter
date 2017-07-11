//
//  Cell.swift
//  GiGi
//
//  Created by Sean Cheng on 29/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class ItemCell: UICollectionViewCell
{
	enum AccessoryType: String
	{
		case none = ""
		case arrow = "Accessory-Default"
		case action = "Accessory-Action"
	}

	lazy var titleLabel: UILabel = UILabel()

	private var _accessoryView: UIImageView?
	private var _iconView: UIImageView?
	private var _seperator: CALayer?
	private var _titleLeadingConstraint: NSLayoutConstraint!

	var accessory: AccessoryType = AccessoryType.none
	{
		didSet
		{
			if (accessory != .none)
			{
				if (_accessoryView == nil)
				{
					_accessoryView = UIImageView()
					contentView.addSubview(_accessoryView!)
					_accessoryView!.translatesAutoresizingMaskIntoConstraints = false
					_accessoryView!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
					_accessoryView!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -1).isActive = true
				}
				let accessoryImage = UIImage(named: accessory.rawValue)
				_accessoryView?.image = accessoryImage
				_accessoryView?.isHidden = false
			}
		}
	}

	var icon: UIImage?
	{
		didSet
		{
			if icon != nil
			{
				if (_iconView == nil)
				{
					_iconView = UIImageView()
					_iconView!.tintColor = Theme.colors[5]
					contentView.addSubview(_iconView!)
					_iconView!.contentMode = .center
					_iconView!.translatesAutoresizingMaskIntoConstraints = false
					_iconView!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
					_iconView!.widthAnchor.constraint(equalToConstant: Constants.cellHeight - 1).isActive = true
					_iconView!.heightAnchor.constraint(equalToConstant: Constants.cellHeight - 1).isActive = true
					_iconView!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1).isActive = true
				}
				_iconView?.image = icon
				_iconView?.isHidden = false
				redrawSeperator()
			} else if let iconView = _iconView { iconView.isHidden = true }
		}
	}

	override init(frame: CGRect)
	{
		super.init(frame: frame)
		titleLabel.font = Theme.CellFont
		contentView.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1).isActive = true
		_titleLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
		_titleLeadingConstraint.isActive = true
		redrawSeperator()
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	func redrawSeperator()
	{
		if let seperator = _seperator { seperator.removeFromSuperlayer() }
		var leftMargin : CGFloat = 15
		if icon != nil { leftMargin = 55 }
		_seperator = drawSeperator(y: frame.height - 1, left: leftMargin, right: Constants.edgeMargin)
		contentView.layer.addSublayer(_seperator!)
		_titleLeadingConstraint.constant = leftMargin
	}

	override func tintColorDidChange()
	{
		super.tintColorDidChange()

		if let iconView = _iconView { iconView.tintColor = tintColor }
		if let accessoryView = _accessoryView { accessoryView.tintColor = Theme.colors[3] }
		backgroundColor = Theme.colors[0]
		titleLabel.textColor = tintColor

		redrawSeperator()
	}
}

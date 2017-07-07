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

	var accessory: AccessoryType = AccessoryType.none
	{
		didSet
		{
			if (accessory != .none)
			{
				if (_accessoryView == nil)
				{
					_accessoryView = UIImageView()
					_accessoryView!.translatesAutoresizingMaskIntoConstraints = false
					contentView.addSubview(_accessoryView!)
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
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = Theme.CellFont
		contentView.addSubview(titleLabel)
		redrawSeperator()
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse()
	{
		super.prepareForReuse()
	}

	override func willMove(toWindow newWindow: UIWindow?)
	{
		super.willMove(toWindow: newWindow)

		var titleLabelLeftMargin : CGFloat = 15

		if let iconView = _iconView
		{
			iconView.removeConstraints(iconView.constraints)
			iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
			iconView.widthAnchor.constraint(equalToConstant: Constants.cellHeight - 1).isActive = true
			iconView.heightAnchor.constraint(equalToConstant: Constants.cellHeight - 1).isActive = true
			iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1).isActive = true
		}

		if let accessoryView = _accessoryView
		{
			titleLabelLeftMargin = 55
			accessoryView.removeConstraints(accessoryView.constraints)
			accessoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
			accessoryView.widthAnchor.constraint(equalToConstant: accessoryView.image!.size.width).isActive = true
			accessoryView.heightAnchor.constraint(equalToConstant: accessoryView.image!.size.height).isActive = true
			accessoryView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -1).isActive = true
		}

		titleLabel.removeConstraints(titleLabel.constraints)
		titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: titleLabelLeftMargin).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1).isActive = true
	}

	func redrawSeperator()
	{
		if let seperator = _seperator { seperator.removeFromSuperlayer() }
		if icon != nil
		{
			_seperator = drawSeperator(y: frame.height - 1, left: 55, right: Constants.edgeMargin)
		} else
		{
			_seperator = drawSeperator(y: frame.height - 1, left: 15, right: Constants.edgeMargin)
		}
		contentView.layer.addSublayer(_seperator!)
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

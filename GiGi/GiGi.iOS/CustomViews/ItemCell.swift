//
//  Cell.swift
//  GiGi
//
//  Created by Sean Cheng on 29/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

@objc protocol ItemCellDelegate: NSObjectProtocol
{
	@objc optional func itemCellDidTriggerAction(cell:ItemCell, actionIndex: Int)
	@objc optional func itemCellDidTappedAccessoryView(cell:ItemCell)
	@objc optional func itemCellDidPanWithAccessoryView(cell:ItemCell, pan:UIPanGestureRecognizer)
}

class ItemCell: UICollectionViewCell
{
	var titleLabel: UILabel = UILabel()
	var icon: UIImage? { didSet { setIcon() } }
	var actions: [ItemAction]? = nil { didSet { setActions() } }
	var hideAccessory: Bool = false

	weak var delegate: ItemCellDelegate?

	private var _seperator: CALayer?
	private var _iconView: UIImageView?
	private var _accessoryView: UIImageView?
	private var _titleLeadingConstraint: NSLayoutConstraint!

	var slideTransition: SlideTransition
	{
		let delegate = UIApplication.shared.delegate as? AppDelegate
		let navController = delegate?.window?.rootViewController as? UINavigationController
		return navController!.slideTransition
	}

	lazy var panGesture: UIPanGestureRecognizer =
	{
		let gesture = UIPanGestureRecognizer(target: self, action: #selector(itemCellDidPanned(gesture:)))
		addGestureRecognizer(gesture)
		gesture.delegate = self
		gesture.isEnabled = false
		gesture.minimumNumberOfTouches = 1
		gesture.maximumNumberOfTouches = 1
		return gesture
	}()

	lazy var tapGesture: UITapGestureRecognizer =
	{
		let gesture = UITapGestureRecognizer(target: self, action: #selector(itemCellDidTapped(gesture:)))
		gesture.isEnabled = false
		_accessoryView?.addGestureRecognizer(gesture)
		return gesture
	}()

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

	override func tintColorDidChange()
	{
		super.tintColorDidChange()

		if let iconView = _iconView { iconView.tintColor = Theme.colors[4] }
		if let accessoryView = _accessoryView { accessoryView.tintColor = Theme.colors[3] }
//		backgroundColor = Theme.colors[0]
		titleLabel.textColor = tintColor

		redrawSeperator()
	}
	
	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes
	{
		let size = contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultLow)
		var newFrame = layoutAttributes.frame
		newFrame.size.width = CGFloat(ceilf(Float(size.width)))
		layoutAttributes.frame = newFrame
		return layoutAttributes
	}

	override func prepareForReuse()
	{
		super.prepareForReuse()
		self.actions = nil
		if let accessoryView = _accessoryView { accessoryView.tintColor = Theme.colors[3] }
		isHighlighted = false
	}

	func isHighlighted(highlight: Bool, animateDuration: TimeInterval = 0)
	{
		UIView.animate(withDuration: animateDuration)
		{
			if highlight
			{
//				self.backgroundColor = Theme.colors[6]
				self.titleLabel.textColor = Theme.colors[0]
				self._iconView?.tintColor = Theme.colors[0]
				self._accessoryView?.tintColor = Theme.colors[0]
				self._seperator?.removeFromSuperlayer()
			} else
			{
//				self.backgroundColor = Theme.colors[0]
				self.titleLabel.textColor = Theme.colors[6]
				self._iconView?.tintColor = Theme.colors[4]
				self._accessoryView?.tintColor = Theme.colors[6]
				self.layer.addSublayer(self._seperator!)
			}
		}
	}
}

extension ItemCell
{
	func redrawSeperator()
	{
		if let seperator = _seperator { seperator.removeFromSuperlayer() }
		var leftMargin : CGFloat = 15
		if icon != nil { leftMargin = 55 }
		_seperator = drawSeperator(y: frame.height - 1, left: leftMargin, right: Constants.edgeMargin)
		contentView.layer.addSublayer(_seperator!)
		_titleLeadingConstraint.constant = leftMargin
	}

	func setIcon()
	{
		if icon != nil
		{
			if (_iconView == nil)
			{
				_iconView = UIImageView()
				_iconView!.tintColor = Theme.colors[4]
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

	func setActions()
	{
		if (hideAccessory == false && _accessoryView == nil)
		{
			_accessoryView = UIImageView()
			_accessoryView?.isUserInteractionEnabled = true
			contentView.addSubview(_accessoryView!)
			_accessoryView!.contentMode = .center
			_accessoryView!.translatesAutoresizingMaskIntoConstraints = false
			_accessoryView!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
			_accessoryView!.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
			_accessoryView!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1).isActive = true
			_accessoryView!.widthAnchor.constraint(equalToConstant: Constants.cellHeight).isActive = true
		}

		if (!hideAccessory)
		{
			let accessoryImageName : String
			if (actions == nil)
			{
				accessoryImageName = "Accessory-Default"
				panGesture.isEnabled = false
				tapGesture.isEnabled = false
			} else
			{
				panGesture.isEnabled = true
				tapGesture.isEnabled = true
				accessoryImageName = "Accessory-Action"
			}
			if let accessoryImage = UIImage(named: accessoryImageName) { _accessoryView?.image = accessoryImage }
		}
	}
}

extension ItemCell: UIGestureRecognizerDelegate
{
	@objc func itemCellDidPanned(gesture: UIPanGestureRecognizer)
	{
		self.slideTransition.itemCellDidPanned(gesture: gesture)
	}

	@objc func itemCellDidTapped(gesture: UITapGestureRecognizer)
	{
		self.slideTransition.itemCellDidTappedAccessoryView(cell: self)
	}

	override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
	{
		if let gesture = gestureRecognizer as? UIPanGestureRecognizer
		{
			let translation = gesture.translation(in: self.superview!)
			if (fabs(translation.x) / fabs(translation.y) <= 1) { return false }
			self.slideTransition.itemCell = self
			return true
		}
		return false
	}
}

//
//  EdgeIndicator.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 24/11/2017.
//

import UIKit
import Cartography

class EdgeIndicator : UIView
{
	enum CornerType { case left, right }
	
	let cornerType : CornerType
	let backgroundImage: UIImageView
	var widthConstraint: NSLayoutConstraint?
	var label = UILabel()
	let title: String
	var more = false
	var target: AnyObject?
	var action: Selector?
	
	var panState : Int = 0
	
	init(cornerType: CornerType, image: UIImage, title: String, more: Bool = false)
	{
		self.cornerType = cornerType
		self.title = title
		self.more = more
	
		switch cornerType
		{
		case .left: backgroundImage = UIImageView(image: #imageLiteral(resourceName: "Background-Edge-Indicator-Left")); break
		case .right: backgroundImage = UIImageView(image: #imageLiteral(resourceName: "Background-Edge-Indicator-Right")); break
		}
		
		super.init(frame: CGRect.zero)
		
		self.backgroundColor = Theme.colors[0]
		self.layer.cornerRadius = Constants.edgeMargin
		self.clipsToBounds = true
		
		self.addSubview(backgroundImage)
		backgroundImage.tintColor = Theme.colors[3]

		let view = UIImageView(image: image)
		view.tintColor = Theme.colors[0]
		view.contentMode = UIViewContentMode.center
		self.addSubview(view)

		addSubview(label)
		label.text = title
		label.font = Font.SearchBarTextFont
		label.textColor = Theme.colors[5]
		
		constrain(view, backgroundImage, label)
		{
			view, backgroundImage, label in
			backgroundImage.top == backgroundImage.superview!.top
			backgroundImage.bottom == backgroundImage.superview!.bottom
			view.top == view.superview!.top
			view.bottom == view.superview!.bottom
			view.width == view.height
			label.centerX == label.superview!.centerX
			label.bottom == label.superview!.bottom
			label.top == label.superview!.top
			widthConstraint = backgroundImage.width == Constants.edgePanMinimumWidth
			
			if self.cornerType == .left
			{
				backgroundImage.leading == backgroundImage.superview!.leading
				view.leading == view.superview!.leading
			}
			else if self.cornerType == .right
			{
				backgroundImage.trailing == backgroundImage.superview!.trailing
				view.trailing == view.superview!.trailing
			}
		}
	}
	
	required init(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}

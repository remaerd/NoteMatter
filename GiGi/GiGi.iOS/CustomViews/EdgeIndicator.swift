//
//  EdgeIndicator.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 24/11/2017.
//

import UIKit

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
		backgroundImage.translatesAutoresizingMaskIntoConstraints = false
		backgroundImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
		backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		
		let view = UIImageView(image: image)
		view.tintColor = Theme.colors[0]
		view.contentMode = UIViewContentMode.center
		self.addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.topAnchor.constraint(equalTo: topAnchor).isActive = true
		view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
		
		addSubview(label)
		label.text = title
		label.font = Font.SearchBarTextFont
		label.textColor = Theme.colors[5]
		label.translatesAutoresizingMaskIntoConstraints = false
		label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		label.topAnchor.constraint(equalTo: topAnchor).isActive = true
		
		widthConstraint = backgroundImage.widthAnchor.constraint(equalToConstant: Constants.edgePanMinimumWidth)
		widthConstraint?.isActive = true
		if self.cornerType == .left
		{
			backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
			view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		}
		else if self.cornerType == .right
		{
			backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
			view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		}
	}
	
	required init(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}

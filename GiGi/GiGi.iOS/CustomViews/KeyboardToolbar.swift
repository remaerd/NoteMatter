//
//  KeyboardToolbar.swift
//  GiGi
//
//  Created by Sean Cheng on 02/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi
import Cartography

class KeyboardButton: UIButton
{
	convenience init(image: UIImage)
	{
		self.init(frame: CGRect.zero)
		layer.cornerRadius = 4
		layer.shadowOffset = CGSize(width: 0, height: 1)
		layer.shadowColor = Theme.colors[3].cgColor
		backgroundColor = Theme.colors[0]
		adjustsImageWhenHighlighted = false
		tintColor = Theme.colors[5]
		setImage(image, for: .normal)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		super.touchesBegan(touches, with: event)
		backgroundColor = Theme.colors[5]
		imageView?.tintColor = Theme.colors[0]
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		super.touchesEnded(touches, with: event)
		if let _ = touches.first
		{
			backgroundColor = Theme.colors[0]
			imageView?.tintColor = Theme.colors[5]
		}
	}
}

class KeyboardToolbar: UIView
{
	let toolbarView : UIView
	let taskView = UIView()
	
	init(views: [UIView])
	{
		toolbarView = UIView()
		super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.keyboardBarHeight))
		
		if Theme.isMorning { backgroundColor = UIColor.init(hex: "D2D5DB") } else { backgroundColor = UIColor.init(hex: "1A1A1A") }
		tintColor = Theme.colors[6]
		taskView.isHidden = true
		var lastView: UIView?
		for _view in views
		{
			toolbarView.addSubview(_view)
			if let _lastView = lastView
			{
				constrain(_view, _lastView)
				{
					view, lastView in
					if views.index(of: _view) == views.count - 1 { view.width == lastView.width * 2 } else { view.width == lastView.width }
					view.centerY == view.superview!.centerY
					view.trailing == lastView.leading - 5
					view.height == 44
				}
				lastView = _view
			}
			else
			{
				lastView = _view
				constrain(_view)
				{
					view in
					view.centerY == view.superview!.centerY
					view.trailing == view.superview!.trailing - 22
					view.height == 44
				}
			}
		}
		
		constrain(lastView!)
		{
			view in
			view.leading == view.superview!.leading + 22
		}
		
		addSubview(toolbarView)
		addSubview(taskView)
		
		constrain(taskView, toolbarView)
		{
			view, toolbar in
			toolbar.edges == view.superview!.edges
			view.leading == view.superview!.leading
			view.trailing == view.superview!.trailing
			view.bottom == toolbar.top
			view.height == Constants.keyboardTaskBarHeight
		}
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}


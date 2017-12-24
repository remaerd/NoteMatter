//
//  SegmentBar.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 11/12/2017.
//

import UIKit
import Cartography

class SegmentBar: UIView
{
	let indicator = UIView()
	var buttons = [UIButton]()
	var index = 0
	
	init(titles: [String])
	{
		super.init(frame: CGRect.zero)
		
		backgroundColor = Theme.colors[4]
		layer.cornerRadius = 6
		
		indicator.backgroundColor = Theme.colors[0]
		indicator.layer.cornerRadius = 4
		
		var lastButton: UIButton? = nil
		
		for title in titles
		{
			let button = UIButton()
			button.setTitle(title, for: .normal)
			button.setTitleColor(Theme.colors[0], for: .normal)
			button.titleLabel?.font = Font.SegmentBarFont
			buttons.append(button)
			addSubview(button)
			
			if let _lastButton = lastButton
			{
				constrain(button,_lastButton)
				{
					button, _lastButton in
					button.width == _lastButton.width
					button.leading == _lastButton.trailing
					button.top == button.superview!.top
					button.bottom == button.superview!.bottom
					if titles.last == title { button.trailing == button.superview!.trailing }
				}
				lastButton = button
			}
			else
			{
				lastButton = button
				constrain(button)
				{
					button in
					button.leading == button.superview!.leading
					button.top == button.superview!.top
					button.bottom == button.superview!.bottom
				}
			}
		}
		
		let pan = UIPanGestureRecognizer(target: self, action: #selector(didPanned(gesture:)))
		addGestureRecognizer(pan)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func didPanned(gesture: UIPanGestureRecognizer)
	{
		
	}
}


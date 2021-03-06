//
//  SlidableKeyboardButton.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 15/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import Cartography

class SlidableKeyboardButton: UIButton
{
	let showTitle: Bool
	let alignRight: Bool
	let sliderContainer = UIView()
	let sliderComponents = UIView()
	let sliderTabBackground: UIView
	var hideTimer: Timer?
	let buttons: [(icon: UIImage, title: String)]
	
	private var _selectedIndex: Int = 0
	var selectedView: UIView?
	var selectedIndex: Int
	{
		get { return _selectedIndex }
		set {
			_selectedIndex = newValue
			if showTitle { self.setTitle(buttons[newValue - 1].title, for: .normal) }
			didChangedSelectedIndex(index: _selectedIndex)
		}
	}
	
	init(buttons: [(icon: UIImage, title: String)], image: UIImage? = nil, showTitle: Bool = false, alignRight: Bool = false)
	{
		self.buttons = buttons
		self.showTitle = showTitle
		self.alignRight = alignRight
		
		var imageButtons = [UIButton]()
		for button in buttons
		{
			let newButton = UIButton()
			newButton.setImage(button.icon, for: .normal)
			newButton.frame = CGRect(x: 0, y: 0, width: Constants.keyboardSliderIconSize, height: Constants.keyboardSliderIconSize)
			newButton.backgroundColor = UIColor.clear
			newButton.layer.cornerRadius = 4
			imageButtons.append(newButton)
		}
		
		var lastButton: UIButton?
		for button in imageButtons
		{
			sliderComponents.addSubview(button)
			
			if let _lastButton = lastButton
			{
				constrain(button, _lastButton)
				{
					button, lastButton in
					button.leading == lastButton.trailing + 10
					button.top == button.superview!.top + 8
				}
				lastButton = button
			}
			else
			{
				constrain(button)
				{
					button in
					button.top == button.superview!.top + 8
					button.leading == button.superview!.leading
				}
				lastButton = button
			}
		}
		
		sliderContainer.addSubview(sliderComponents)
		if (showTitle) { sliderTabBackground = UIImageView(image: #imageLiteral(resourceName: "Background-Keyboard-Slider-Left")) } else { sliderTabBackground = UIImageView(image: #imageLiteral(resourceName: "Background-Keyboard-Slider-Center")) }
		
		super.init(frame: CGRect.zero)
		
		if showTitle
		{
			titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
			setTitle(buttons.first!.title, for: .normal)
			self.setTitleColor(Theme.colors[5], for: .normal)
			self.setTitleColor(Theme.colors[0], for: .selected)
		} else if let image = image { setImage(image, for: .normal) } else { setImage(buttons.first!.icon, for: .normal) }
		
		layer.cornerRadius = 4
		layer.shadowOffset = CGSize(width: 0, height: 1)
		layer.shadowColor = Theme.colors[1].cgColor
		backgroundColor = Theme.colors[0]
		showsTouchWhenHighlighted = false
		
		sliderContainer.isHidden = true
		sliderContainer.layer.cornerRadius = 4
		sliderContainer.backgroundColor = Theme.colors[5]
		sliderContainer.tintColor = Theme.colors[0]
		
		sliderTabBackground.isHidden = true
		sliderTabBackground.tintColor = Theme.colors[5]
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		super.touchesBegan(touches, with: event)
		sliderContainer.isHidden = false
		sliderTabBackground.isHidden = false
		self.tintColor = Theme.colors[0]
		self.isSelected = true
		self.sliderContainer.alpha = 1
		self.sliderTabBackground.alpha = 1
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		super.touchesEnded(touches, with: event)
		if let _ = touches.first
		{
			hideTimer?.invalidate()
			hideTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(hideSlider), userInfo: nil, repeats: false)
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		super.touchesMoved(touches, with: event)
		if let touch = touches.first?.location(in: superview), self.frame.contains(touch)
		{
			
		}
	}
	
	@objc func hideSlider()
	{
		self.isSelected = false
		UIView.animate(withDuration: 0.2, animations:
		{
			self.tintColor = Theme.colors[5]
			self.sliderContainer.alpha = 0
			self.sliderTabBackground.alpha = 0
		}, completion:
		{ (_) in
			self.sliderContainer.isHidden = true
			self.sliderTabBackground.isHidden = true
		})
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	func didChangedSelectedIndex(index: Int)
	{
		selectedView?.backgroundColor = UIColor.clear
		if index == 0 { selectedView = nil }
		else
		{
			selectedView = sliderComponents.subviews[index - 1]
			selectedView?.backgroundColor = Theme.colors[6]
		}
	}
	
	override func didMoveToSuperview()
	{
		super.didMoveToSuperview()
		
		if let imageView = imageView, sliderContainer.superview == nil
		{
			insertSubview(sliderTabBackground, belowSubview: imageView)
			insertSubview(sliderContainer, belowSubview: imageView)
		}
		
		constrain(sliderContainer, sliderComponents, sliderTabBackground)
		{
			container, components, tab in
			let numberOfButtons = CGFloat(sliderComponents.subviews.count) + 1
			var width = numberOfButtons * 28 + ( numberOfButtons + 1 ) * 5
			if showTitle { width += Constants.edgeMargin }
			
			container.width == width
			container.bottom == container.superview!.top - Constants.edgeMargin
			container.height == 46
			
			if showTitle { container.leading == container.superview!.leading }
			else if alignRight { container.trailing == container.superview!.trailing + 28 + 5 }
			else { container.leading == container.superview!.leading - 28 - 5 }
			
			components.leading == container.leading + Constants.edgeMargin
			components.trailing == container.trailing - Constants.edgeMargin
			components.bottom == container.bottom
			components.top == container.top
			
			tab.bottom == tab.superview!.bottom
			
			if showTitle
			{
				tab.height == 58
				tab.leading == tab.superview!.leading
				tab.trailing == tab.superview!.trailing + 5
			}
			else
			{
				tab.height == 54
				tab.leading == tab.superview!.leading - 4
				tab.trailing == tab.superview!.trailing + 5
			}
		}
	}
}

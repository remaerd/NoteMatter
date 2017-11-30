//
//  SlidableKeyboardButton.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 15/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import Cartography

protocol KeyboardSlidableButtonDelegate: NSObjectProtocol
{
	func didSelected(index: Int)
}

class SlidableKeyboardButton: UIButton
{
	// 是否允许为空值。SelectedIndex 为 0 时，不显示 SelectedBackgroundView
	let nullable: Bool
	let showTitle: Bool
	let alignRight: Bool
	let sliderContainer = UIView()
	let sliderComponents = UIView()
	let sliderTabBackground: UIView
	var hideTimer: Timer?
	
	weak var delegate: KeyboardSlidableButtonDelegate?
	
	var _selectedIndex: Int = 0
	var selectedIndex: Int
	{
		get { return _selectedIndex }
		set
		{
			let previousIndex = _selectedIndex
			if (nullable)
			{
				if newValue > sliderComponents.subviews.count { _selectedIndex = 0 } else { _selectedIndex = newValue }
			} else
			{
				if newValue >= sliderComponents.subviews.count { _selectedIndex = 0 } else { _selectedIndex = newValue }
			}
			didChangedSelectedIndex(previous: previousIndex, current: _selectedIndex)
		}
	}
	
	init(buttons: [(icon: UIImage, title: String)], image: UIImage? = nil, showTitle: Bool = false, alignRight: Bool = false, nullable: Bool = false)
	{
		self.nullable = nullable
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
		
		for button in imageButtons
		{
			sliderComponents.addSubview(button)
		}
		
		sliderContainer.addSubview(sliderComponents)
		if (showTitle) { sliderTabBackground = UIImageView(image: #imageLiteral(resourceName: "Background-Keyboard-Slider-Left")) } else { sliderTabBackground = UIImageView(image: #imageLiteral(resourceName: "Background-Keyboard-Slider-Center")) }
		
		super.init(frame: CGRect.zero)
		
		if showTitle
		{
			titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
			setTitle(buttons.first!.title, for: .normal)
		} else if let image = image { setImage(image, for: .normal) } else { setImage(buttons.first!.icon, for: .normal) }
		
		layer.cornerRadius = 4
		layer.shadowOffset = CGSize(width: 0, height: 1)
		layer.shadowColor = Theme.colors[1].cgColor
		backgroundColor = Theme.colors[0]
		showsTouchWhenHighlighted = false
		
//		sliderComponents.alignment = .center
//		sliderComponents.distribution = .equalCentering
		
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
		UIView.animate(withDuration: 0.2)
		{
			self.tintColor = Theme.colors[0]
			self.titleLabel?.textColor = Theme.colors[0]
			self.self.sliderContainer.alpha = 1
			self.self.sliderTabBackground.alpha = 1
		}
		selectedIndex += 1
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
		UIView.animate(withDuration: 0.2, animations:
			{
				self.tintColor = Theme.colors[5]
				self.titleLabel?.textColor = Theme.colors[5]
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
	
	func didChangedSelectedIndex(previous: Int, current: Int)
	{
		if (nullable)
		{
			if (current == 0) { sliderComponents.subviews[previous - 1].backgroundColor = UIColor.clear } else
			{
				if (previous != 0) { sliderComponents.subviews[previous - 1].backgroundColor = UIColor.clear }
				sliderComponents.subviews[current - 1].backgroundColor = Theme.colors[6]
			}
		} else
		{
			sliderComponents.subviews[previous].backgroundColor = UIColor.clear
			sliderComponents.subviews[current].backgroundColor = Theme.colors[4]
		}
	}
	
	override func didMoveToSuperview()
	{
		super.didMoveToSuperview()
		
		if let imageView = imageView, sliderContainer.superview == nil
		{
			insertSubview(sliderTabBackground, belowSubview: imageView)
			insertSubview(sliderContainer, belowSubview: imageView)
		} else if let titleLabel = imageView, sliderContainer.superview == nil
		{
			insertSubview(sliderTabBackground, belowSubview: titleLabel)
			insertSubview(sliderContainer, belowSubview: titleLabel)
		}
		
		let buttonWidth : CGFloat
		if showTitle { buttonWidth = Constants.keyboardButtonWidth * 2 + Constants.keyboardButtonMargin } else { buttonWidth = Constants.keyboardButtonWidth }
		
		constrain(self, sliderContainer, sliderComponents, sliderTabBackground)
		{
			view, container, components, background in
			view.width == buttonWidth
			view.height == Constants.keyboardButtonHeight
			
			let numberOfButtons : CGFloat = CGFloat(sliderComponents.subviews.count) + 1
			var barWidth = (numberOfButtons * 28) + ((numberOfButtons + 1) * Constants.keyboardButtonMargin)
			if (showTitle) { barWidth += Constants.edgeMargin }
			
			container.width == barWidth
			container.bottom == view.top - Constants.edgeMargin
			container.height == Constants.keyboardSliderBarHeight
			
			if showTitle { container.leading == view.leading }
			else if alignRight { container.trailing == view.trailing + Constants.keyboardButtonWidth + Constants.keyboardButtonMargin }
			else { container.leading == view.leading - Constants.keyboardButtonWidth - Constants.keyboardButtonMargin }
			
			components.bottom == container.bottom
			components.leading == container.leading + Constants.edgeMargin
			components.trailing == container.trailing - Constants.edgeMargin
			components.top == container.top
			
			background.bottom == view.bottom
			
			if showTitle
			{
				background.height == 58
				background.width == 69
				background.leading == view.leading
			}
			else
			{
				background.height == 54
				background.width == 38
				background.leading == view.leading - 4
			}
		}
	}
}

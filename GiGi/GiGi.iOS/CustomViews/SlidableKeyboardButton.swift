import Foundation

//
//  SlidableKeyboardButton.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 15/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

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
	let sliderComponents: UIStackView
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
				if newValue > sliderComponents.arrangedSubviews.count { _selectedIndex = 0 } else { _selectedIndex = newValue }
			} else
			{
				if newValue >= sliderComponents.arrangedSubviews.count { _selectedIndex = 0 } else { _selectedIndex = newValue }
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
		
		sliderComponents = UIStackView(arrangedSubviews: imageButtons)
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
		
		sliderComponents.alignment = .center
		sliderComponents.distribution = .equalCentering
		
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
			if (current == 0) { sliderComponents.arrangedSubviews[previous - 1].backgroundColor = UIColor.clear } else
			{
				if (previous != 0) { sliderComponents.arrangedSubviews[previous - 1].backgroundColor = UIColor.clear }
				sliderComponents.arrangedSubviews[current - 1].backgroundColor = Theme.colors[6]
			}
		} else
		{
			sliderComponents.arrangedSubviews[previous].backgroundColor = UIColor.clear
			sliderComponents.arrangedSubviews[current].backgroundColor = Theme.colors[4]
		}
	}
	
	override func didMoveToSuperview()
	{
		super.didMoveToSuperview()
		translatesAutoresizingMaskIntoConstraints = false
		
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
		widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
		heightAnchor.constraint(equalToConstant: Constants.keyboardButtonHeight).isActive = true
		
		let numberOfButtons : CGFloat = CGFloat(sliderComponents.arrangedSubviews.count) + 1
		var barWidth = (numberOfButtons * 28) + ((numberOfButtons + 1) * Constants.keyboardButtonMargin)
		if (showTitle) { barWidth += Constants.edgeMargin }
		sliderContainer.widthAnchor.constraint(equalToConstant: barWidth).isActive = true
		sliderContainer.bottomAnchor.constraint(equalTo: topAnchor, constant: -Constants.edgeMargin).isActive = true
		sliderContainer.heightAnchor.constraint(equalToConstant: Constants.keyboardSliderBarHeight).isActive = true
		sliderContainer.translatesAutoresizingMaskIntoConstraints = false
		
		if showTitle { sliderContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true } else if alignRight
		{
			sliderContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.keyboardButtonWidth + Constants.keyboardButtonMargin).isActive = true
		} else
		{
			sliderContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -Constants.keyboardButtonWidth - Constants.keyboardButtonMargin).isActive = true
		}
		
		sliderComponents.translatesAutoresizingMaskIntoConstraints = false
		sliderComponents.bottomAnchor.constraint(equalTo: sliderContainer.bottomAnchor).isActive = true
		sliderComponents.trailingAnchor.constraint(equalTo: sliderContainer.trailingAnchor, constant: -10).isActive = true
		sliderComponents.topAnchor.constraint(equalTo: sliderContainer.topAnchor).isActive = true
		sliderComponents.leadingAnchor.constraint(equalTo: sliderContainer.leadingAnchor, constant: 10).isActive = true
		
		sliderTabBackground.translatesAutoresizingMaskIntoConstraints = false
		sliderTabBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		
		if (showTitle)
		{
			sliderTabBackground.heightAnchor.constraint(equalToConstant: 58).isActive = true
			sliderTabBackground.widthAnchor.constraint(equalToConstant: 69).isActive = true
			sliderTabBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		} else
		{
			sliderTabBackground.heightAnchor.constraint(equalToConstant: 54).isActive = true
			sliderTabBackground.widthAnchor.constraint(equalToConstant: 38).isActive = true
			sliderTabBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -4).isActive = true
		}
	}
}
